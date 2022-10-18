require "test_helper"

class HotlinesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hotline = hotlines(:one)
  end

  test "should get index" do
    get hotlines_url
    assert_response :success
  end

  test "should get new" do
    get new_hotline_url
    assert_response :success
  end

  test "should create hotline" do
    assert_difference("Hotline.count") do
      post hotlines_url, params: { hotline: { maxlen: @hotline.maxlen, name: @hotline.name, retry: @hotline.retry, strategy: @hotline.strategy, timeout: @hotline.timeout, title: @hotline.title, wrapuptime: @hotline.wrapuptime } }
    end

    assert_redirected_to hotline_url(Hotline.last)
  end

  test "should show hotline" do
    get hotline_url(@hotline)
    assert_response :success
  end

  test "should get edit" do
    get edit_hotline_url(@hotline)
    assert_response :success
  end

  test "should update hotline" do
    patch hotline_url(@hotline), params: { hotline: { maxlen: @hotline.maxlen, name: @hotline.name, retry: @hotline.retry, strategy: @hotline.strategy, timeout: @hotline.timeout, title: @hotline.title, wrapuptime: @hotline.wrapuptime } }
    assert_redirected_to hotline_url(@hotline)
  end

  test "should destroy hotline" do
    assert_difference("Hotline.count", -1) do
      delete hotline_url(@hotline)
    end

    assert_redirected_to hotlines_url
  end
end
