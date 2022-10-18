require "test_helper"

class MohsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @moh = mohs(:one)
  end

  test "should get index" do
    get mohs_url
    assert_response :success
  end

  test "should get new" do
    get new_moh_url
    assert_response :success
  end

  test "should create moh" do
    assert_difference("Moh.count") do
      post mohs_url, params: { moh: { description: @moh.description, name: @moh.name } }
    end

    assert_redirected_to moh_url(Moh.last)
  end

  test "should show moh" do
    get moh_url(@moh)
    assert_response :success
  end

  test "should get edit" do
    get edit_moh_url(@moh)
    assert_response :success
  end

  test "should update moh" do
    patch moh_url(@moh), params: { moh: { description: @moh.description, name: @moh.name } }
    assert_redirected_to moh_url(@moh)
  end

  test "should destroy moh" do
    assert_difference("Moh.count", -1) do
      delete moh_url(@moh)
    end

    assert_redirected_to mohs_url
  end
end
