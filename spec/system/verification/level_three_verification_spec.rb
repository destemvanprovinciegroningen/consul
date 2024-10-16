require "rails_helper"

describe "Level three verification" do
  before do
    Zipcode.create!(code: "9713BH")
  end

  scenario "Verification with correct residency zipcode" do
    user = create(:user)

    login_as(user)

    visit account_path
    click_link "Verify my account"

    select "DNI", from: "residence_document_type"
    fill_in "residence_document_number", with: "12345678Z"
    select_date "31-#{I18n.l(Date.current.at_end_of_year, format: "%B")}-1980",
                from: "residence_date_of_birth"

    fill_in "residence_postal_code", with: "9713BH"
    check "residence_terms_of_service"

    click_button "new_residence_submit"

    expect(page).to have_content "Account verified"
  end

  scenario "Verification with wrong residency zipcode" do
    user = create(:user)

    login_as(user)

    visit account_path
    click_link "Verify my account"

    select "DNI", from: "residence_document_type"
    fill_in "residence_document_number", with: "12345678Z"
    select_date "31-#{I18n.l(Date.current.at_end_of_year, format: "%B")}-1980",
                from: "residence_date_of_birth"

    fill_in "residence_postal_code", with: "9713BA"
    check "residence_terms_of_service"

    click_button "new_residence_submit"

    expect(page).to have_css ".form-error", text: "Citizens from this postal code cannot participate"
    expect(page).not_to have_content "Account verified"
  end

  scenario "Verification using an already registered document number", :consul do
    create(:user, document_number: "12345678Z", document_type: "1")

    user = create(:user)

    create(:verified_user, document_number: "12345678Z", document_type: "1")

    login_as(user)

    visit account_path
    click_link "Verify my account"

    select "DNI", from: "residence_document_type"
    fill_in "residence_document_number", with: "12345678Z"
    select_date "31-#{I18n.l(Date.current.at_end_of_year, format: "%B")}-1980",
                from: "residence_date_of_birth"

    fill_in "residence_postal_code", with: "9713BH"
    check "residence_terms_of_service"

    click_button "new_residence_submit"

    expect(page).to have_content "Thank you for requesting your maximum security code " \
                                 "(only required for the final votes). In a few days " \
                                 "we will send it to the address featuring in the data " \
                                 "we have on file."
  end
end
