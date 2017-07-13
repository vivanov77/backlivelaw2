require 'test_helper'

class CategorySubscriptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category_subscription = category_subscriptions(:one)
  end

  test "should get index" do
    get category_subscriptions_url
    assert_response :success
  end

  test "should get new" do
    get new_category_subscription_url
    assert_response :success
  end

  test "should create category_subscription" do
    assert_difference('CategorySubscription.count') do
      post category_subscriptions_url, params: { category_subscription: { category_id: @category_subscription.category_id, price: @category_subscription.price, timesubscription: @category_subscription.timesubscription } }
    end

    assert_redirected_to category_subscription_url(CategorySubscription.last)
  end

  test "should show category_subscription" do
    get category_subscription_url(@category_subscription)
    assert_response :success
  end

  test "should get edit" do
    get edit_category_subscription_url(@category_subscription)
    assert_response :success
  end

  test "should update category_subscription" do
    patch category_subscription_url(@category_subscription), params: { category_subscription: { category_id: @category_subscription.category_id, price: @category_subscription.price, timesubscription: @category_subscription.timesubscription } }
    assert_redirected_to category_subscription_url(@category_subscription)
  end

  test "should destroy category_subscription" do
    assert_difference('CategorySubscription.count', -1) do
      delete category_subscription_url(@category_subscription)
    end

    assert_redirected_to category_subscriptions_url
  end
end
