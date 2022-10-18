require "test_helper"

class ExtensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @exten = extens(:one)
  end

  test "should get index" do
    get extens_url
    assert_response :success
  end

  test "should get new" do
    get new_exten_url
    assert_response :success
  end

  test "should create exten" do
    assert_difference("Exten.count") do
      post extens_url, params: { exten: { account_id: @exten.account_id, decription: @exten.decription, exten: @exten.exten, name: @exten.name, secret: @exten.secret, sip_id: @exten.sip_id } }
    end

    assert_redirected_to exten_url(Exten.last)
  end

  test "should show exten" do
    get exten_url(@exten)
    assert_response :success
  end

  test "should get edit" do
    get edit_exten_url(@exten)
    assert_response :success
  end

  test "should update exten" do
    patch exten_url(@exten), params: { exten: { account_id: @exten.account_id, decription: @exten.decription, exten: @exten.exten, name: @exten.name, secret: @exten.secret, sip_id: @exten.sip_id } }
    assert_redirected_to exten_url(@exten)
  end

  test "should destroy exten" do
    assert_difference("Exten.count", -1) do
      delete exten_url(@exten)
    end

    assert_redirected_to extens_url
  end
end
