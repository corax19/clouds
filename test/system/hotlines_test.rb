require "application_system_test_case"

class HotlinesTest < ApplicationSystemTestCase
  setup do
    @hotline = hotlines(:one)
  end

  test "visiting the index" do
    visit hotlines_url
    assert_selector "h1", text: "Hotlines"
  end

  test "should create hotline" do
    visit hotlines_url
    click_on "New hotline"

    fill_in "Maxlen", with: @hotline.maxlen
    fill_in "Name", with: @hotline.name
    fill_in "Retry", with: @hotline.retry
    fill_in "Strategy", with: @hotline.strategy
    fill_in "Timeout", with: @hotline.timeout
    fill_in "Title", with: @hotline.title
    fill_in "Wrapuptime", with: @hotline.wrapuptime
    click_on "Create Hotline"

    assert_text "Hotline was successfully created"
    click_on "Back"
  end

  test "should update Hotline" do
    visit hotline_url(@hotline)
    click_on "Edit this hotline", match: :first

    fill_in "Maxlen", with: @hotline.maxlen
    fill_in "Name", with: @hotline.name
    fill_in "Retry", with: @hotline.retry
    fill_in "Strategy", with: @hotline.strategy
    fill_in "Timeout", with: @hotline.timeout
    fill_in "Title", with: @hotline.title
    fill_in "Wrapuptime", with: @hotline.wrapuptime
    click_on "Update Hotline"

    assert_text "Hotline was successfully updated"
    click_on "Back"
  end

  test "should destroy Hotline" do
    visit hotline_url(@hotline)
    click_on "Destroy this hotline", match: :first

    assert_text "Hotline was successfully destroyed"
  end
end
