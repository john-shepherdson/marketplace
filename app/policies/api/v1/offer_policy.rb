# frozen_string_literal: true

class Api::V1::OfferPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.joins(service: [resource_organisation: [provider_data_administrators: [:data_administrator]]])
           .where("data_administrators.email = ? AND offers.status = ? AND services.status != ?",
                  user.email, "published", "deleted")
    end
  end

  def show?
    service_administered_by? && !service_deleted? && record.published?
  end

  def create?
    service_administered_by? && !service_deleted? && record.published?
  end

  def update?
    service_administered_by? && !service_deleted? && record.published?
  end

  def destroy?
    service_administered_by? && !service_deleted? && record.published?
  end

  def permitted_attributes
    [:name, :description, :order_type, :order_url, :primary_oms_id, :internal, { oms_params: {},
                                                                                 parameters: [:id, :type, :label, :description, :unit, :value_type, :value,
                                                                                              { config: [:mode, :minimum, :maximum, :minItems, :maxItems, :exclusiveMinimum,
                                                                                                         :exclusiveMaximum, :start_price, :step_price, :currency, { values: [] }] }] }]
  end

  private

  def service_administered_by?
    record.service.administered_by?(user)
  end

  def service_deleted?
    record.service.deleted?
  end
end
