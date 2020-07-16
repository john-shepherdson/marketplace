# frozen_string_literal: true

FactoryBot.define do
  factory :access_type do
    sequence(:name) { |n| "access type #{n}" }
    sequence(:eid) { |n| "access_type-#{n}" }
    sequence(:description) { |n| "Description #{n}" }
    sequence(:extras) { |n| {} }
  end
end
