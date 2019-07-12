# frozen_string_literal: true

class Project < ApplicationRecord
  CUSTOMER_TYPOLOGIES = {
    single_user: "single_user",
    research: "research",
    private_company: "private_company",
    project: "project"
  }

  ISSUE_STATUSES = {
      jira_require_migration: 100,
      jira_active: 0,
      jira_deleted: 1,
      jira_uninitialized: 2,
      jira_errored: 3
  }

  enum customer_typology: CUSTOMER_TYPOLOGIES
  enum issue_status: ISSUE_STATUSES

  NON_EUROPEAN = ISO3166::Country.new("N/E")
  INTERNATIONAL = ISO3166::Country.new("I/N")
  NON_APPLICABLE = ISO3166::Country.new("N/A")

  allowed_countries = [NON_APPLICABLE, INTERNATIONAL, NON_EUROPEAN] +
        ISO3166::Country.find_all_countries_by_region("Europe").sort

  belongs_to :user
  has_many :project_items, dependent: :destroy
  has_many :project_research_areas, dependent: :destroy
  has_many :research_areas, through: :project_research_areas
  has_many :messages, as: :messageable, dependent: :destroy

  serialize :country_of_customer, CountrySerializer
  serialize :country_of_collaboration, CountrySerializer

  validates :name,
            presence: true,
            uniqueness: { scope: :user, message: "Project name need to be unique" }
  validates :email, presence: true
  validates :reason_for_access, presence: true
  validates :country_of_customer, presence: true, if: :single_user_or_private_company?,
             inclusion: { in: allowed_countries }, on: :create
  validates :customer_typology, presence: true

  validates :organization, presence: true, if: :single_user_or_community?
  validates :webpage, presence: true, url: true, if: :single_user_or_community?

  validates :user_group_name, presence: true, if: :research?

  validates :project_name, presence: true, if: :project?
  validates :project_website_url, url: true, presence: true, if: :project?

  validates :company_name, presence: true, if: :private_company?
  validates :country_of_collaboration, presence: true, if: :research_or_project?,
             multiselect_choices: { collection: allowed_countries }, on: :create
  validates :company_website_url,  url: true, presence: true, if: :private_company?

  validates :issue_id, presence: true, if: :require_jira_issue?
  validates :issue_key, presence: true, if: :require_jira_issue?

  def single_user_or_community?
    single_user? || research?
  end

  def research_or_project?
    research? || project?
  end

  def single_user_or_private_company?
    single_user? || private_company?
  end

  private

    def require_jira_issue?
      jira_active? || jira_deleted?
    end
end
