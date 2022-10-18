require "application_system_test_case"

class SipsTest < ApplicationSystemTestCase
  setup do
    @sip = sips(:one)
  end

  test "visiting the index" do
    visit sips_url
    assert_selector "h1", text: "Sips"
  end

  test "should create sip" do
    visit sips_url
    click_on "New sip"

    fill_in "Decription", with: @sip.decription
    fill_in "Host", with: @sip.host
    fill_in "Number", with: @sip.number
    fill_in "Secret", with: @sip.secret
    fill_in "Sipid", with: @sip.sipid
    click_on "Create Sip"

    assert_text "Sip was successfully created"
    click_on "Back"
  end

  test "should update Sip" do
    visit sip_url(@sip)
    click_on "Edit this sip", match: :first

    fill_in "Decription", with: @sip.decription
    fill_in "Host", with: @sip.host
    fill_in "Number", with: @sip.number
    fill_in "Secret", with: @sip.secret
    fill_in "Sipid", with: @sip.sipid
    click_on "Update Sip"

    assert_text "Sip was successfully updated"
    click_on "Back"
  end

  test "should destroy Sip" do
    visit sip_url(@sip)
    click_on "Destroy this sip", match: :first

    assert_text "Sip was successfully destroyed"
  end
end
