require "rails_helper"

describe "Help page" do
  context "Index" do
    scenario "Help menu and page is visible if feature is enabled" do
      Setting["feature.help_page"] = true
      Setting["org_name"] = "CONSUL"

      customize_help_page

      visit help_path

      expect(page).to have_content("CONSUL is a platform for citizen participation")
    end
  end

  scenario "renders the SDG help page link when the feature is enabled" do
    Setting["feature.help_page"] = true
    Setting["feature.sdg"] = true

    visit help_path

    expect(page).to have_link "Sustainable Development Goals help", href: sdg_help_path
  end

  scenario "does not render the SDG help page link when the feature is disabled" do
    Setting["feature.sdg"] = nil

    visit help_path

    expect(page).not_to have_link "Sustainable Development Goals help"
  end
end
