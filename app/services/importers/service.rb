# frozen_string_literal: true

class Importers::Service
  include Importable

  def initialize(data, synchronized_at, eosc_registry_base_url, token = nil, source = "jms")
    @data = data
    @synchronized_at = synchronized_at
    @source = source
    @eosc_registry_base_url = eosc_registry_base_url
    @token = token
  end

  def call
    case @source
    when "jms"
      providers = Array(@data.dig("resourceProviders", "resourceProvider"))
      multimedia = Array(@data.dig("multimedia", "multimedia")) || []
      use_cases_url = Array(@data.dig("useCases", "useCase")) || []
      scientific_domains = if @data.dig("scientificDomains", "scientificDomain").is_a?(Array)
                             @data.dig("scientificDomains", "scientificDomain").map { |sd| sd["scientificSubdomain"] }
                           else
                             @data.dig("scientificDomains", "scientificDomain", "scientificSubdomain")
                           end
      categories = if @data.dig("categories", "category").is_a?(Array)
                     @data.dig("categories", "category").map { |c| c["subcategory"] }
                   else
                     @data.dig("categories", "category", "subcategory")
                   end
      target_users = @data.dig("targetUsers", "targetUser")
      access_types = Array(@data.dig("accessTypes", "accessType"))
      access_modes = Array(@data.dig("accessModes", "accessMode"))
      tag_list = Array(@data.dig("tags", "tag")) || []
      geographical_availabilities = Array(@data.dig("geographicalAvailabilities",
                                                    "geographicalAvailability") || "WW")
      language_availability = Array(@data.dig("languageAvailabilities", "languageAvailability"))
                              .map(&:upcase) || ["EN"]
      resource_geographic_locations = Array(@data.dig("resourceGeographicLocations",
                                                      "resourceGeographicLocation")) || []
      public_contacts = Array.wrap(@data.dig("publicContacts", "publicContact"))
                             .map { |c| PublicContact.new(map_contact(c)) } || []
      certifications = Array(@data.dig("certifications", "certification"))
      standards = Array(@data.dig("standards", "standard"))
      open_source_technologies = Array(@data.dig("openSourceTechnologies", "openSourceTechnology"))
      last_update = @data["lastUpdate"].present? ? Time.zone.at(@data["lastUpdate"].to_i) : nil
      changelog = Array(@data.dig("changeLog", "changeLog"))
      required_services = map_related_services(Array(@data.dig("requiredResources", "requiredResource")))
      related_services = map_related_services(Array(@data.dig("relatedResources", "relatedResource")))
      related_platforms = Array(@data.dig("relatedPlatforms", "relatedPlatform")) || []
      funding_bodies = map_funding_bodies(@data.dig("fundingBody", "fundingBody"))
      funding_programs = map_funding_programs(@data.dig("fundingPrograms", "fundingProgram"))
      grant_project_names = Array(@data.dig("grantProjectNames", "grantProjectName"))

    when "rest"
      providers = Array(@data["resourceProviders"]) || []
      multimedia = Array(@data["multimedia"]) || []
      use_cases_url = Array(@data["useCases"])
      scientific_domains = @data["scientificDomains"]&.map { |sd| sd["scientificSubdomain"] } || []
      categories = @data["categories"]&.map { |c| c["subcategory"] } || []
      target_users = @data["targetUsers"]
      access_types = Array(@data["accessTypes"])
      access_modes = Array(@data["accessModes"])
      tag_list = Array(@data["tags"]) || []
      geographical_availabilities = Array(@data["geographicalAvailabilities"] || "WW")
      language_availability = @data["languageAvailabilities"].map(&:upcase) || ["EN"]
      resource_geographic_locations = Array(@data["resourceGeographicLocations"]) || []
      public_contacts = Array(@data["publicContacts"])&.map { |c| PublicContact.new(map_contact(c)) } || []
      certifications = Array(@data["certifications"])
      standards = Array(@data["standards"])
      open_source_technologies = Array(@data["openSourceTechnologies"])
      last_update = @data["lastUpdate"]
      changelog = Array(@data["changeLog"])
      required_services = map_related_services(Array(@data["requiredResources"]))
      related_services = map_related_services(Array(@data["relatedResources"]))
      related_platforms = Array(@data["relatedPlatforms"]) || []
      funding_bodies = map_funding_bodies(Array(@data["fundingBody"]))
      funding_programs = map_funding_programs(Array(@data["fundingPrograms"]))
      grant_project_names = Array(@data["grantProjectNames"])
    end

    status = ENV["RESOURCE_IMPORT_STATUS"] || "published"

    main_contact = MainContact.new(map_contact(@data["mainContact"])) if @data["mainContact"] || nil

    {
      pid: @data["id"],
      # Basic
      name: @data["name"],
      resource_organisation: map_provider(@data["resourceOrganisation"],
                                          @eosc_registry_base_url,
                                          token: @token),
      providers: providers.uniq.map do |p|
                   map_provider(p, @eosc_registry_base_url,
                                token: @token)
                 end,
      webpage_url: @data["webpage"] || "",
      # Marketing
      description: @data["description"],
      tagline: @data["tagline"].presence || "-",
      multimedia: multimedia,
      use_cases_url: use_cases_url,
      # Classification
      scientific_domains: map_scientific_domains(scientific_domains),
      categories: map_categories(categories) || [],
      target_users: map_target_users(target_users),
      access_types: map_access_types(access_types),
      access_modes: map_access_modes(access_modes),
      tag_list: tag_list,
      # Availability
      geographical_availabilities: geographical_availabilities,
      language_availability: language_availability,
      # Location
      resource_geographic_locations: resource_geographic_locations,
      # Contact
      main_contact: main_contact,
      public_contacts: public_contacts,
      helpdesk_email: @data["helpdeskEmail"] || "",
      security_contact_email: @data["securityContactEmail"] || "",
      # Maturity
      trl: map_trl(@data["trl"]),
      life_cycle_status: map_life_cycle_status(@data["lifeCycleStatus"]),
      certifications: certifications,
      standards: standards,
      open_source_technologies: open_source_technologies,
      version: @data["version"] || "",
      last_update: last_update,
      changelog: changelog,
      # Dependencies
      required_services: required_services,
      related_services: related_services,
      related_platforms: related_platforms,
      # Attribution
      funding_bodies: funding_bodies,
      funding_programs: funding_programs,
      grant_project_names: grant_project_names,
      # Management
      helpdesk_url: @data["helpdeskPage"] || "",
      manual_url: @data["userManual"] || "",
      terms_of_use_url: @data["termsOfUse"] || "",
      privacy_policy_url: @data["privacyPolicy"] || "",
      access_policies_url: @data["accessPolicy"] || "",
      sla_url: @data["serviceLevel"] || "",
      training_information_url: @data["trainingInformation"] || "",
      status_monitoring_url: @data["statusMonitoring"] || "",
      maintenance_url: @data["maintenance"] || "",
      # Order
      order_type: map_order_type(@data["orderType"]),
      order_url: @data["order"] || "",
      # Financial
      payment_model_url: @data["paymentModel"] || "",
      pricing_url: @data["pricing"] || "",
      status: status,
      synchronized_at: @synchronized_at
    }
  end
end
