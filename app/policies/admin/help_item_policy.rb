# frozen_string_literal: true

class Admin::HelpItemPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def new?
    admin?
  end

  def create?
    admin?
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end

  def permitted_attributes
    [
      :title, :help_section_id, :content, :position
    ]
  end

  private
    def admin?
      user&.admin?
    end
end
