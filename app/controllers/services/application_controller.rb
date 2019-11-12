# frozen_string_literal: true

class Services::ApplicationController < ApplicationController
  before_action :authenticate_user!
  before_action :load_and_authenticate_service!

  layout "order"

  attr_reader :wizard
  helper_method :saved_state

  private

    def session_key
      @service.id.to_s
    end

    def ensure_in_session!
      unless saved_state
        redirect_to service_offers_path(@service),
                    alert: "Service request template not found"
      end
    end

    def load_and_authenticate_service!
      @service = Service.friendly.find(params[:service_id])
      authorize(@service, :order?)
      @wizard = ProjectItem::Wizard.new(@service)
    end

    def save_in_session(step)
      session[session_key] = step.project_item.attributes
    end

    def saved_state
      session[session_key]
    end
end
