# frozen_string_literal: true

class Ess::CatalogueSerializer < ApplicationSerializer
  attributes :id,
             :pid,
             :name,
             :abbreviation,
             :legal_entity,
             :description,
             :multimedia_urls,
             :scientific_domains,
             :street_name_and_number,
             :postal_code,
             :city,
             :region,
             :country,
             :public_contacts,
             :participating_countries,
             :networks,
             :affiliations,
             :updated_at

  attribute :hosting_legal_entities, key: :hosting_legal_entity
  attribute :legal_statuses, key: :legal_status
  attribute :website, key: :webpage_url
  attribute :pid, key: :slug
end
