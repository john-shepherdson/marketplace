# frozen_string_literal: true

class UserActionController < ApplicationController
  # Store user action in recommendation system
  def create
    return if Mp::Application.config.recommender_host.nil?

    request_body = {
      timestamp: params[:timestamp],
      source: JSON.parse(params[:source].to_json),
      target: JSON.parse(params[:target].to_json),
      action: JSON.parse(params[:user_action].to_json)
    }

    request_body[:user_id] = current_user.id unless current_user.nil?

    request_body[:unique_id] = cookies[:client_uid]

    unless request_body[:source]["root"]["service_id"].nil?
      request_body[:source]["root"]["service_id"] = request_body[:source]["root"]["service_id"].to_i
    end

    is_recommendation_panel = params[:source]["root"]["type"] != "other"
    request_body[:source]["root"]["panel_id"] = "v1" if is_recommendation_panel

    # We're publish user actions to both JMS under the "recommender" topic
    # as well as to Recommender server directly for now
    # Recommender cannot receive JMS messages yet

    if %w[all recommender].include? Mp::Application.config.user_actions_target
      Probes::ProbesJob.perform_later(request_body.to_json)
    end

    if %w[all databus].include? Mp::Application.config.user_actions_target
      Jms::PublishJob.perform_later(request_body.to_json, :databus)
    end
  end
end
