require "application_system_test_case"

class AgentsTest < ApplicationSystemTestCase
  setup do
    @agent = agents(:one)
  end

  test "visiting the index" do
    visit agents_url
    assert_selector "h1", text: "Agents"
  end

  test "should create agent" do
    visit agents_url
    click_on "New agent"

    fill_in "Account", with: @agent.account_id
    fill_in "Exten", with: @agent.exten_id
    fill_in "Hotline", with: @agent.hotline_id
    fill_in "Priority", with: @agent.priority
    click_on "Create Agent"

    assert_text "Agent was successfully created"
    click_on "Back"
  end

  test "should update Agent" do
    visit agent_url(@agent)
    click_on "Edit this agent", match: :first

    fill_in "Account", with: @agent.account_id
    fill_in "Exten", with: @agent.exten_id
    fill_in "Hotline", with: @agent.hotline_id
    fill_in "Priority", with: @agent.priority
    click_on "Update Agent"

    assert_text "Agent was successfully updated"
    click_on "Back"
  end

  test "should destroy Agent" do
    visit agent_url(@agent)
    click_on "Destroy this agent", match: :first

    assert_text "Agent was successfully destroyed"
  end
end
