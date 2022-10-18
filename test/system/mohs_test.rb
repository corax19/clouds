require "application_system_test_case"

class MohsTest < ApplicationSystemTestCase
  setup do
    @moh = mohs(:one)
  end

  test "visiting the index" do
    visit mohs_url
    assert_selector "h1", text: "Mohs"
  end

  test "should create moh" do
    visit mohs_url
    click_on "New moh"

    fill_in "Description", with: @moh.description
    fill_in "Name", with: @moh.name
    click_on "Create Moh"

    assert_text "Moh was successfully created"
    click_on "Back"
  end

  test "should update Moh" do
    visit moh_url(@moh)
    click_on "Edit this moh", match: :first

    fill_in "Description", with: @moh.description
    fill_in "Name", with: @moh.name
    click_on "Update Moh"

    assert_text "Moh was successfully updated"
    click_on "Back"
  end

  test "should destroy Moh" do
    visit moh_url(@moh)
    click_on "Destroy this moh", match: :first

    assert_text "Moh was successfully destroyed"
  end
end
