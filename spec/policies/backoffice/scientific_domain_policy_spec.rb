# frozen_string_literal: true

require "rails_helper"

RSpec.describe Backoffice::ScientificDomainPolicy, backend: true do
  subject { described_class }

  permissions :index?, :show?, :new?, :create?, :edit?, :destroy? do
    it "grants access for service portfolio manager" do
      expect(subject).to permit(build(:user, roles: [:service_portfolio_manager]))
    end

    it "denies for other users" do
      expect(subject).to_not permit(build(:user))
    end
  end
end
