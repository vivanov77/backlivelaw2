require 'test_helper'

class ChatRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @chat_request = chat_requests(:one)
  end

  test "should get index" do
    get chat_requests_url
    assert_response :success
  end

  test "should get new" do
    get new_chat_request_url
    assert_response :success
  end

  test "should create chat_request" do
    assert_difference('ChatRequest.count') do
      post chat_requests_url, params: { chat_request: { guest_login: @chat_request.guest_login, guest_password: @chat_request.guest_password } }
    end

    assert_redirected_to chat_request_url(ChatRequest.last)
  end

  test "should show chat_request" do
    get chat_request_url(@chat_request)
    assert_response :success
  end

  test "should get edit" do
    get edit_chat_request_url(@chat_request)
    assert_response :success
  end

  test "should update chat_request" do
    patch chat_request_url(@chat_request), params: { chat_request: { guest_login: @chat_request.guest_login, guest_password: @chat_request.guest_password } }
    assert_redirected_to chat_request_url(@chat_request)
  end

  test "should destroy chat_request" do
    assert_difference('ChatRequest.count', -1) do
      delete chat_request_url(@chat_request)
    end

    assert_redirected_to chat_requests_url
  end
end
