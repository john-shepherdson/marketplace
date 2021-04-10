# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :eventable, polymorphic: true
  belongs_to :project, -> { where(events: { eventable_type: "Project" }).includes(:events) },
             foreign_key: "eventable_id", optional: true
  belongs_to :project_item, -> { where(events: { eventable_type: "ProjectItem" }).includes(:events) },
             foreign_key: "eventable_id", optional: true
  belongs_to :message, -> { where(events: { eventable_type: "Message" }).includes(:events) },
             foreign_key: "eventable_id", optional: true

  enum action: {
    create: "create",
    update: "update"
  }, _prefix: true

  validates :action, presence: true
  validates :updates, presence: true, if: :action_update?
  validates :updates, absence: true, unless: :action_update?
  validate :updates_schema?, if: :action_update?

  private
    def updates_schema?
      JSON::Validator.validate!(UPDATES_SCHEME, updates)
    rescue JSON::Schema::ValidationError => e
      errors.add(:updates, e.message)
    end

    UPDATES_SCHEME = {
      type: "array",
      items: {
        type: "object",
        minItems: 1,
        properties: {
          field: { type: "string" },
          before: {},
          after: {},
        },
        additionalProperties: false,
        required: [:field, :before, :after]
      }
    }
end
