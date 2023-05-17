# frozen_string_literal: true

module LandingPageHelper
  SEARCH_ITEMS = {
    software: "Software",
    service: "Services",
    publication: "Publications",
    dataset: "Data",
    "data-source": "Data Sources",
    training: "Training Materials"
    # Will be unlocked in the next release
    # guideline: "Interoperability Guidelines"
  }.freeze

  def external_search_base_url
    Rails.configuration.search_service_base_url
  end

  def user_dashboard_url
    Rails.configuration.user_dashboard_url
  end

  def providers_dashboard_url
    Rails.configuration.providers_dashboard_url
  end
end
