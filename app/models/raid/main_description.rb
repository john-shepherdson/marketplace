# frozen_string_literal: true

class Raid::MainDescription < Raid::Description
    after_initialize :set_type
  
    def set_type
      self.description_type = "primary"
    end
  end
  