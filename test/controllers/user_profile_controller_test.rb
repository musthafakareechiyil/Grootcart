require "test_helper"

class UserProfileControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_profile_index_url
    assert_response :success
  end

  test "should get orders" do
    get user_profile_orders_url
    assert_response :success
  end

  test "should get addresses" do
    get user_profile_addresses_url
    assert_response :success
  end

  test "should get account" do
    get user_profile_account_url
    assert_response :success
  end
end
