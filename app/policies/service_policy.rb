# frozen_string_literal: true

class ServicePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(status: Statusable::VISIBLE_STATUSES)
    end
  end

  def order?
    (record.offers.inclusive.size + record.bundles.published.size).positive?
  end

  def offers_show?
    enough_to_show? && any_published_offers?
  end

  def bundles_show?
    any_published_bundled_offers?
  end

  def errors_show?
    user.service_portfolio_manager? || record.administered_by?(user)
  end

  def data_administrator?
    record.administered_by?(user)
  end

  private

  def enough_to_show?
    record.offers.inclusive.size + record.bundles.published.size > 1
  end

  def any_published_bundled_offers?
    record.bundles.published.size.positive? ||
      (
        record.offers.select(&:bundled?).size.positive? &&
          record
            .offers
            .select(&:bundled?)
            .map(&:bundles)
            .flatten
            .map { |bundle| bundle.service.status }
            .any? { |status| status.in?(Statusable::PUBLIC_STATUSES) }
      )
  end

  def any_published_offers?
    record.offers? && record.offers.any? { |o| !o.bundle_exclusive && o.published? }
  end
end
