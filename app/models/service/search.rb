# frozen_string_literal: true

module Service::Search
  extend ActiveSupport::Concern

  included do
    # ELASTICSEARCH
    # scope :search_import working with should_indexe?
    # and define which services are indexed in elasticsearch
    searchkick word_middle: [:name, :tagline, :description, :offer_names],
      highlight: [:name, :tagline]
  end

  # search_data are definition whitch
  # fields are mapped to elasticsearch
  def search_data
    {
      service_id: id,
      name: name,
      tagline: tagline,
      description: description,
      status: status,
      rating: rating,
      categories: categories.map(&:id),
      research_areas: search_research_area_ids,
      providers: providers.map(&:id),
      platforms: platforms.map(&:id),
      target_groups: target_groups.map(&:id),
      service_type: [service_type] << offers.map(&:offer_type),
      tags: tag_list,
      source: upstream&.source_type,
      offers: offers.ids,
      offer_names:  offers.map(&:name)
    }
  end

  private
    def search_research_area_ids
      (research_areas.map(&:ancestor_ids) + research_areas.map(&:id))
        .flatten.uniq
    end
end
