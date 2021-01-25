# frozen_string_literal: true

class Provider::PcCreateOrUpdate
  def initialize(eic_provider)
    @eic_provider =  eic_provider
    @eid = eic_provider["id"]
  end

  def call
    prov = map_provider(@eic_provider)
    mapped_provider = Provider.joins(:sources).find_by("provider_sources.source_type": "eic",
                                                       "provider_sources.eid": @eid)
    if mapped_provider.nil?
      provider = Provider.new(prov)
      if provider.save!
        ProviderSource.create!(provider_id: provider.id, source_type: "eic", eid: @eid)
      end
      provider
    else
      mapped_provider.update(prov)
      mapped_provider
    end
  end

  private
    def map_provider(data)
      {
        name: data["name"],
        data_administrators: Array(data.dig("users", "user")).
          map { |admin| DataAdministrator.new(map_data_administrator(admin)) }
      }
    end

    def map_data_administrator(data)
      {
        first_name: data["name"],
        last_name: data["surname"],
        email: data["email"]
      }
    end
end
