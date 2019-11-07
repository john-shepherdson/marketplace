# frozen_string_literal: true

module ProjectItem::Wizard
  class Base
    include ActiveModel::Model
    attr_accessor :project_item, :foo

    delegate(*::ProjectItem.attribute_names.map { |a| [a, "#{a}="] }.flatten,
             to: :project_item)

    delegate :service, :offer, :project, :properties, :properties=, to: :project_item
    delegate :parameters, to: :offer

    def initialize(project_item_attributes)
      @project_item = ::ProjectItem.new(project_item_attributes)
    end

    def model_name
      project_item.model_name
    end
  end

  class OfferSelectionStep < Base
    validates :offer, presence: true

    def error
      "Please select one of the offer"
    end
  end

  class ConfStep < OfferSelectionStep
    include ProjectItem::Customization
    include ProjectItem::VoucherValidation

    delegate :properties, :created?, to: :project_item

    def error
      "Please correct errors presented below"
    end
  end

  class SummaryStep < ConfStep
    include ProjectItem::ProjectValidation
    delegate :properties?, to: :project_item
  end
end
