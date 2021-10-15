# frozen_string_literal: true

class Services::SummariesController < Services::ApplicationController
  before_action :ensure_in_session!

  def show
    if prev_visible_step.valid?
      @step = step(session[session_key])
      setup_show_variables!
    else
      redirect_to url_for([@service, prev_visible_step_key]), alert: prev_visible_step.error
    end
  end

  def create
    @step = step(summary_params)
    @bundle_params = session[:bundle]

    if @step.valid? & verify_recaptcha(model: @step, attribute: :verified_recaptcha)
      do_create(@step.project_item, @bundle_params)
    else
      setup_show_variables!
      flash.now[:alert] = @step.error
      render "show"
    end
  end

  private
    def next_title
      I18n.t("services.summary.#{helpers.map_view_to_order_type(@offer)}.order.title")
    end

    def do_create(project_item_template, bundle_params)
      authorize(project_item_template)

      project_item = ProjectItem::Create.new(project_item_template, message_text, bundle_params: bundle_params).call

      if project_item.persisted?
        session.delete(session_key)
        session.delete(:selected_project)
        session.delete(:bundle)
        send_user_action
        Matomo::SendRequestJob.perform_later(project_item, "AddToProject")
        redirect_to project_service_path(project_item.project, project_item),
                                  notice: "Service ordered successfully"
      else
        redirect_to url_for([@service, prev_visible_step_key]),
                    alert: "Service request configuration is invalid"
      end
    end

    def step_key
      :summary
    end

    def summary_params
      session[session_key].merge(params.require(:project_item).permit(:project_id))
    end

    def setup_show_variables!
      @projects = policy_scope(current_user.projects.active)
      @offer = @step.offer
      @bundle_params = session[:bundle]
    end

    def message_text
      params[:project_item][:additional_comment]
    end

    def project_item_template
      CustomizableProjectItem.new(session[session_key])
    end

    def send_user_action
      if Mp::Application.config.recommender_host.nil?
        return
      end

      source_id = SecureRandom.uuid

      request_body = {
        timestamp: Time.now.utc.iso8601,
        source: JSON.parse(@recommendation_previous),
        target: { page_id: polymorphic_url(@service, routing_type: :path), visit_id: source_id },
        action: { order: true, type: "button", text: "" },
        user_id: current_user.id,
        unique_id: cookies[:client_uid]
      }

      Probes::ProbesJob.perform_later(request_body.to_json)
    end
end
