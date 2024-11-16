require "test_helper"

class IntroduceControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get introduce_show_url
    assert_response :success
  end
end
