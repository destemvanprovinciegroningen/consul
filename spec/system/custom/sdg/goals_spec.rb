require "rails_helper"

describe "SDG Goals" do
  before do
    Setting["feature.sdg"] = true
    Setting["sdg.process.debates"] = true
    Setting["sdg.process.proposals"] = true
  end

  describe "SDG navigation link" do
    scenario "routes to the goals index" do
      visit sdg_goals_path

      expect(page).to have_current_path sdg_goals_path
    end
  end
end
