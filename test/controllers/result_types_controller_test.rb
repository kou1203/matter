require "test_helper"

class ResultTypesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get result_types_new_url
    assert_response :success
  end

  test "should get edit" do
    get result_types_edit_url
    assert_response :success
  end
end
