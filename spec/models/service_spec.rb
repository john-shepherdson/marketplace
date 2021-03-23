# frozen_string_literal: true

require "rails_helper"

RSpec.describe Service do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:tagline) }
  it { should validate_presence_of(:rating) }

  it { should have_many(:providers) }
  it { should have_many(:categorizations).dependent(:destroy) }
  it { should have_many(:offers).dependent(:restrict_with_error) }
  it { should have_many(:categories) }
  it { should have_many(:service_scientific_domains).dependent(:destroy) }
  it { should have_many(:funding_bodies) }
  it { should have_many(:funding_programs) }
  it { should have_many(:service_vocabularies).dependent(:destroy) }

  it { should belong_to(:upstream).required(false) }

  it "sets first category as default" do
    c1, c2 = create_list(:category, 2)
    service = create(:service, categories: [c1, c2])

    expect(service.categorizations.first.main).to be_truthy
    expect(service.categorizations.second.main).to be_falsy
  end

  it "allows to have only one main category" do
    c1, c2 = create_list(:category, 2)
    service = create(:service, categories: [c1])

    service.categorizations.create(category: c2, main: true)
    old_main = service.categorizations.find_by(category: c1)

    expect(old_main.main).to be_falsy
  end


  it "has main category" do
    main, other = create_list(:category, 2)
    service = create(:service, categories: [main, other])

    expect(service.main_category).to eq(main)
  end

  it "has rating" do
    expect(create(:service).rating).to eq(0.0)
  end

  it "has related services" do
    s1, s2, s3 = create_list(:service, 3)

    ServiceRelationship.create(source: s1, target: s2)
    ServiceRelationship.create(source: s1, target: s3)

    expect(s1.related_services).to contain_exactly(s2, s3)
  end

  it "requires service_order_target to be an email" do
    service = create(:service)
    service.order_target = "not-valid-email"
    expect(service.valid?).to be_falsey
    service.order_target = "valid@email.com"
    expect(service.valid?).to be_truthy
  end

  it "allows service_order_target to be blank" do
    service = create(:service)
    service.order_target = ""
    expect(service.valid?).to be_truthy
  end

  context "#owned_by?" do
    it "is true when user is in the owners list" do
      owner = create(:user)
      service = create(:service, owners: [owner])

      expect(service.owned_by?(owner)).to be_truthy
    end

    it "is false when user is not in the owers list" do
      stranger = create(:user)
      service = create(:service)

      expect(service.owned_by?(stranger)).to be_falsy
    end
  end

  context "#self.administered_by" do
    it "return all services managed by user" do
      data_admin_user = create(:user)
      data_admin_1 = create(:data_administrator, email: data_admin_user.email)
      data_admin_2 = create(:data_administrator, email: data_admin_user.email)

      other_data_admin_user = create(:user)
      other_data_admin = create(:data_administrator, email: other_data_admin_user.email)

      provider1 = create(:provider, data_administrators: [data_admin_1])
      provider2 = create(:provider, data_administrators: [data_admin_2, other_data_admin])
      provider3 = create(:provider, data_administrators: [other_data_admin])

      service_1 = create(:service, resource_organisation: provider1)
      service_2 = create(:service, resource_organisation: provider1)
      service_3 = create(:service, resource_organisation: provider2)
      service_4 = create(:service, resource_organisation: provider3)

      expect(Service.administered_by(data_admin_user)).to match_array([service_1, service_2, service_3])
      expect(Service.administered_by(other_data_admin_user)).to match_array([service_3, service_4])
    end
  end

  context "OMS validations" do
    subject { build(:service, oms: build_list(:resource_dedicated_oms, 2)) }
    it { should have_many(:oms) }
  end
end
