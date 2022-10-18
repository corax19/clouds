require "test_helper"

class SoundsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get sounds_index_url
    assert_response :success
  end

  test "should get new" do
    get sounds_new_url
    assert_response :success
  end

  test "should get create" do
    get sounds_create_url
    assert_response :success
  end

  test "should get destroy" do
    get sounds_destroy_url
    assert_response :success
  end
end
