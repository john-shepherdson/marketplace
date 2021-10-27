# frozen_string_literal: true

class HelpSection < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_many :help_items, -> { order(:position) }, dependent: :destroy, inverse_of: :help_section

  validates :title, presence: true
end
