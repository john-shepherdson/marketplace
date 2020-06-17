# frozen_string_literal: true

require "mini_magick"

class Service::PcCreateOrUpdate
  def initialize(eic_service,
                 eic_base_url,
                 logger,
                 unirest: Unirest)
    @logger = logger
    @unirest = unirest
    @eic_base_url = eic_base_url
    @eid = eic_service["id"]
    @best_effort_category_mapping = {
        "storage": "Storage",
        "training": "Training & Support",
        "security": "Security & Operations",
        "analytics": "Processing & Analysis",
        "data": "Data management",
        "compute": "Compute",
        "networking": "Networking",
    }.stringify_keys
    @eic_service =  eic_service
    @is_active = @eic_service["active"]
  end

  def call
    service = map_service(@eic_service)
    mapped_service = Service.joins(:sources).find_by("service_sources.source_type": "eic",
                                                     "service_sources.eid": @eid)
    if mapped_service.nil? && @is_active
      service = Service.new(service)
      save_logo(service, @eic_service["symbol"])

      if service.save!
        log "Created new service: #{service.id}"
        ServiceSource.create!(service_id: service.id, source_type: "eic", eid: @eid)
        service.offers.create!(name: "Offer", description: "#{service.name} Offer",
                               order_type: "open_access",
                               webpage: service.webpage_url, status: service.status)
      end
      service
    elsif mapped_service && !@is_active
      Service::Draft.new(mapped_service).call
      log "Draft service: #{mapped_service.id}"
      mapped_service
    else
      save_logo(mapped_service, @eic_service["symbol"])
      mapped_service.update!(service)
      log "Service with id: #{mapped_service.id} successfully updated"
      mapped_service
    end
  end

  private
    def map_service(data)
      main_contact = MainContact.new(map_contact(data["mainContact"])) if data["mainContact"] || nil

      { name: data["name"],
        description: [ReverseMarkdown.convert(data["description"],
                                             unknown_tags: :bypass,
                                             github_flavored: false),
                      data["options"],
                      data["userValue"],
                      data["userBase"]].join("\n"),
        tagline: data["tagline"].blank? ? "NO IMPORTED TAGLINE" : data["tagline"],
        language_availability: Array(data["languages"]["language"] || "EN"),
        geographical_availabilities: Array(data["geographicalAvailabilities"]["geographicalAvailability"] || "WW"),
        dedicated_for: [],
        main_contact: main_contact,
        public_contacts: Array(data["publicContacts"]["publicContact"])&.
            map { |c| PublicContact.new(map_contact(c)) } || [],
        terms_of_use_url: data["termsOfUse"]["termOfUse"] || "",
        access_policies_url: data["price"],
        sla_url: data["serviceLevelAgreement"] || "",
        webpage_url: data["url"] || "",
        manual_url: data["userManual"] || "",
        helpdesk_url: data["helpdesk"] || "",
        training_information_url: data["trainingInformation"] || "",
        status_monitoring_url: data["statusMonitoring"] || "",
        maintenance_url: data["maintenance"] || "",
        order_url: data["order"] || "",
        payment_model_url: data["paymentModel"] || "",
        pricing_url: data["pricing"] || "",
        trl: Trl.where(eid: data["trl"]),
        life_cycle_status: LifeCycleStatus.where(eid: data["lifeCycleStatus"]),
        order_type: "open_access",
        status: "published",
        funding_bodies: map_funding_bodies(data["fundingBody"]),
        funding_programs: map_funding_programs(data["fundingPrograms"]),
        resource_organisation: map_provider(data["resourceOrganisation"]),
        providers: Array(data["resourceProviders"]["resourceProviders"])&.map { |p| map_provider(p) },
        categories: map_category(data["category"]),
        scientific_domains: [scientific_domain_other],
        version: data["version"] || "",
        target_users: map_target_users(data["targetUsers"]["targetUsers"])
      }
    end

    def map_target_users(target_users)
      TargetUser.where(eid: target_users)
    end

    def map_provider(prov_eid)
      mapped_provider = Provider.joins(:sources).find_by("provider_sources.source_type": "eic",
                                                         "provider_sources.eid": prov_eid)

      if mapped_provider.nil?
        begin
          prov = @unirest.get("#{@eic_base_url}/api/provider/#{prov_eid}",
                              headers: { "Accept" => "application/json" })
        rescue Errno::ECONNREFUSED
          abort("\n Exited with errors - could not connect to #{@eic_base_url}\n")
        end

        if prov.code != 200
          abort("\n Exited with errors - could not fetch data (code: #{prov.code})\n")
        end
        provider  = Provider.create!(name: prov.body["name"])
        ProviderSource.create!(provider_id: provider.id, source_type: "eic", eid: prov_eid)
        provider
      else
        mapped_provider
      end
    end

    def save_logo(service, image_url)
      begin
        logo = open(image_url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)
        logo_content_type = logo.content_type

        if logo_content_type == "image/svg+xml"
          img = MiniMagick::Image.read(logo, ".svg")
          img.format "png" do |convert|
            convert.args.unshift "800x800"
            convert.args.unshift "-resize"
            convert.args.unshift "1200"
            convert.args.unshift "-density"
            convert.args.unshift "none"
            convert.args.unshift "-background"
          end

          logo = StringIO.new
          logo.write(img.to_blob)
          logo.seek(0)
          logo_content_type = "image/png"
          logo
        end
      rescue OpenURI::HTTPError, Errno::EHOSTUNREACH, SocketError => e
        log "\nERROR - there was a problem processing image for #{@eid} #{image_url}: #{e}\n"
      rescue => e
        log "\nERROR - there was a unexpected problem processing image for #{@eid} #{image_url}: #{e}\n"
      end

      unless logo.nil?
        service.logo.attach(io: logo, filename: @eid, content_type: logo_content_type)
      end
    end

    def map_category(category)
      if @best_effort_category_mapping[category]
        [Category.find_by!(name: @best_effort_category_mapping[category])]
      else
        []
      end
    end

    def map_contact(contact)
      contact&.transform_keys { |k| k.to_s.underscore } || nil
    end

    def map_funding_bodies(funding_bodies)
      FundingBody.where(eid: funding_bodies)
    end

    def map_funding_programs(funding_programs)
      FundingProgram.where(eid: funding_programs)
    end

    def scientific_domain_other
      ScientificDomain.find_by!(name: "Other")
    end

    def log(msg)
      @logger.info(msg)
    end
end
