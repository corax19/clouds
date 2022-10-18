require "application_system_test_case"

class ExtensTest < ApplicationSystemTestCase
  setup do
    @exten = extens(:one)
  end

  test "visiting the index" do
    visit extens_url
    assert_selector "h1", text: "Extens"
  end

  test "should create exten" do
    visit extens_url
    click_on "New exten"

    fill_in "Account", with: @exten.account_id
    fill_in "Decription", with: @exten.decription
    fill_in "Exten", with: @exten.exten
    fill_in "Name", with: @exten.name
    fill_in "Secret", with: @exten.secret
    fill_in "Sip", with: @exten.sip_id
    click_on "Create Exten"

    assert_text "Exten was successfully created"
    click_on "Back"
  end

  test "should update Exten" do
    visit exten_url(@exten)
    click_on "Edit this exten", match: :first

    fill_in "Account", with: @exten.account_id
    fill_in "Decription", with: @exten.decription
    fill_in "Exten", with: @exten.exten
    fill_in "Name", with: @exten.name
    fill_in "Secret", with: @exten.secret
    fill_in "Sip", with: @exten.sip_id
    click_on "Update Exten"

    assert_text "Exten was successfully updated"
    click_on "Back"
  end

  test "should destroy Exten" do
    visit exten_url(@exten)
    click_on "Destroy this exten", match: :first

    assert_text "Exten was successfully destroyed"
  end
end
