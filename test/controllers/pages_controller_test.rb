require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index2" do
    get pages_index2_url
    assert_response :success
  end

  test "should get index3" do
    get pages_index3_url
    assert_response :success
  end
end
