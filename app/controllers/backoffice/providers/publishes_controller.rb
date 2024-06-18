# frozen_string_literal: true

class Backoffice::Providers::PublishesController < Backoffice::ApplicationController
  before_action :find_and_authorize

  def create
    if Provider::Publish.call(@provider)
      flash[:notice] = _("Provider published successfully")
    else
      flash[:alert] = "Provider not published. Reason: #{@provider.errors.full_messages.join(", ")}"
    end
    redirect_to backoffice_provider_path(@provider)
  end

  private

  def find_and_authorize
    @provider = Provider.friendly.find(params[:provider_id])
    authorize(@provider, :publish?)
  end
end
