# frozen_string_literal: true

require "rails_helper"

RSpec.describe Provider::PcCreateOrUpdate do
  let(:provider_response) { create(:eic_provider_response) }

  it "should create provider with source" do
    expect {
      described_class.new(provider_response).call
    }.to change { Provider.count }.by(1)

    provider = Provider.last

    expect(provider.name).to eq("Test Provider 2")
    expect(provider.sources.length).to eq(1)
    expect(provider.sources[0].eid).to eq("tp")
  end

  it "should update provider" do
    provider = create(:provider, name: "new provider")
    create(:provider_source, provider: provider, source_type: "eic", eid: "new.provider")

    expect {
      described_class.new(create(:eic_provider_response,
                                 eid: "new.provider",
                                 name: "Supper new name for updated  provider")).call
    }.to change { Provider.count }.by(0)

    updated_provider = Provider.find(provider.id)

    expect(updated_provider.name).to eq("Supper new name for updated  provider")
    expect(updated_provider.sources.length).to eq(1)
    expect(updated_provider.sources[0].eid).to eq("new.provider")
  end
end
