# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Service browsing" do
  include OmniauthHelper

  let(:user) { create(:user) }

  context "as logged in user" do

    before { checkin_sign_in_as(user) }

    scenario "allows to see details" do
      service = create(:service)

      visit service_path(service)

      expect(page.body).to have_content service.title
      expect(page.body).to have_content service.description
      expect(page.body).to have_content service.tagline
    end

    scenario "I see Ask Question" do
      service = create(:service)

      visit service_path(service)

      expect(page).to have_content "Want to ask a question about this service?"

    end

    scenario "I can see question-modal if I click on link", js: true do
      service = create(:service)

      visit service_path(service)

      find("#modal-show").click

      expect(page).to have_css("div#question-modal.show")
    end

    scenario "I can sand message about service", js: true do
      user1, user2 = create_list(:user, 2)
      service = create(:service, contact_emails: [user1.email, user2.email])

      visit service_path(service)

      find("#modal-show").click

      within("#question-modal") do
        fill_in("service_question_text", with: "text")
      end

      expect { click_on "SEND" }.
        to change { ActionMailer::Base.deliveries.count }.by(2)
      expect(page).to have_content("Your message was successfully sended")
    end
  end

  scenario "shows related services" do
    service, related = create_list(:service, 2)
    ServiceRelationship.create!(source: service, target: related)

    visit service_path(service)

    expect(page.body).to have_content "Services you can use with this service"
    expect(page.body).to have_content related.title
  end

  scenario "does not show related services section when no related services" do
    service = create(:service)

    visit service_path(service)

    expect(page.body).to_not have_content "Services you can use with this service"
  end
  context "service has no offers" do
    scenario "service offers section are not displayed" do
      service = create(:service)

      visit service_path(service)

      expect(page.body).not_to have_content("Service offers")
    end
  end

  context "as not logged in user" do
    scenario "I need to login to asks service question" do
      service = create(:service)

      visit service_path(service)

      expect(page).to have_content "If you want ask question about service please login!"
    end
  end
end


RSpec.feature "Service filtering and sorting" do
  before(:each) do
    area = create(:research_area, name: "area 1")
    provider = create(:provider, name: "first provider")
    service = create(:service, title: "AAAA Service", rating: 5.0, dedicated_for: ["VO"])
    service.research_areas << area
    service.providers << provider
    create(:service, title: "BBBB Service", rating: 3.0, dedicated_for: ["Providers"])
    create(:service, title: "CCCC Service", rating: 4.0, dedicated_for: ["Researchers"])
    create(:service, title: "DDDD Something 1", rating: 4.1)
    create(:service, title: "DDDD Something 2", rating: 4.0)
    create(:service, title: "DDDD Something 3", rating: 3.9)
    sleep(1)
  end

  scenario "searching in top bar will preserve existing query params", js: true do
    visit services_path(sort: "title")

    fill_in "q", with: "DDDD Something"
    click_on(id: "query-submit")

    expect(page.body.index("DDDD Something 1")).to be < page.body.index("DDDD Something 2")
    expect(page.body.index("DDDD Something 2")).to be < page.body.index("DDDD Something 3")

    expect(page).to have_selector(".media", count: 3)
  end

  scenario "clicking filter button in side bar will preserve existing query params", js: true do
    visit services_path(sort: "title", q: "DDDD Something", utf8: "✓")

    click_on(id: "filter-submit")

    expect(page.body.index("DDDD Something 1")).to be < page.body.index("DDDD Something 2")
    expect(page.body.index("DDDD Something 2")).to be < page.body.index("DDDD Something 3")

    expect(page).to have_selector(".media", count: 3)
  end

  scenario "selecting sorting will set query param and preserve existing ones", js: true do
    visit services_path(q: "DDDD Something", utf8: "✓")

    select "by rate 1-5", from: "sort"

    # For turbolinks to load
    sleep(1)

    expect(page.body.index("DDDD Something 3")).to be < page.body.index("DDDD Something 2")
    expect(page.body.index("DDDD Something 2")).to be < page.body.index("DDDD Something 1")
  end

  scenario "limit number of services per page" do
    create_list(:service, 2)

    visit services_path(per_page: "1")

    expect(page).to have_selector(".media", count: 1)
  end


  scenario "multiselect toggle", js: true do
    visit services_path

    expect(page).to have_selector("input[name='providers[]']:not([style*=\"display: none\"])", count: 5)
    click_on("Show 2 more")
    expect(page).to have_selector("input[name='providers[]']:not([style*=\"display: none\"])", count: 7)
    click_on("Show less")
    expect(page).to have_selector("input[name='providers[]']:not([style*=\"display: none\"])", count: 5)
  end

  scenario "multiselect shows checked element regardless of toggle state", js: true do
    visit services_path

    expect(page).to have_selector("input[name='providers[]']", count: 5)
    click_on("Show 2 more")
    expect(page).to have_selector("input[name='providers[]']", count: 7)
    find(:css, "input[name='providers[]'][value='#{Provider.order(:name).last.id}']").set(true)
    click_on(id: "filter-submit")
    expect(page).to have_selector("input[name='providers[]']", count: 6)
  end

  scenario "multiselect does not show toggle button if everything is shown", js: true do
    visit services_path

    expect(page).to have_selector("input[name='providers[]']", count: 5)
    click_on("Show 2 more")
    find(:css, "input[name='providers[]'][value='#{Provider.joins(:services)
                                                      .order(:name)
                                                      .group("providers.id")
                                                      .order(:name)[-1].id}']").set(true)
    find(:css, "input[name='providers[]'][value='#{Provider.joins(:services)
                                                      .order(:name)
                                                      .group("providers.id")
                                                      .order(:name)[-2].id}']").set(true)
    click_on(id: "filter-submit")

    expect(page).to_not have_selector("#providers > a")
  end

  scenario "toggle button changes number of providers to show", js: true do
    visit services_path
    click_on("Show 2 more")
    find(:css, "input[name='providers[]'][value='#{Provider.order(:name).last.id}']").set(true)
    click_on(id: "filter-submit")

    find("#providers > a", text: "Show 1 more")
  end

  scenario "searching via providers", js: true do
    visit services_path
    find(:css, "input[name='providers[]'][value='#{Provider.order(:name).first.id}']").set(true)
    click_on(id: "filter-submit")

    expect(page).to have_selector(".media", count: 1)
    expect(page).to have_selector("input[name='providers[]']" +
                                      "[value='#{Provider.order(:name).first.id}'][checked='checked']")
  end

  scenario "searching via rating", js: true do
    visit services_path
    select "★★★★★", from: "rating"
    click_on(id: "filter-submit")

    expect(page).to have_selector(".media", count: 1)
  end

  scenario "searching vis research_area" do
    visit services_path
    select ResearchArea.first.name, from: "research_area"
    click_on(id: "filter-submit")

    expect(page).to have_selector(".media", count: 1)
  end

  scenario "searching via dedicated_for", js: true do
    visit services_path
    find(:css, "input[name='dedicated_for[]'][value='VO']").set(true)
    click_on(id: "filter-submit")

    expect(page).to have_selector(".media", count: 1)
    expect(page).to have_selector("input[name='dedicated_for[]'][value='VO'][checked='checked']")
  end

  scenario "searching via location", js: true do
    `pending "add test after implementing location to filtering #{__FILE__}"`
  end
end
