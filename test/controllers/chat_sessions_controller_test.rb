require 'test_helper'

class ChatSessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @chat_session = chat_sessions(:one)
  end

  test "should get index" do
    get chat_sessions_url
    assert_response :success
  end

  test "should get new" do
    get new_chat_session_url
    assert_response :success
  end

  test "should create chat_session" do
    assert_difference('ChatSession.count') do
      post chat_sessions_url, params: { chat_session: { clientable_id: @chat_session.clientable_id, clientable_type: @chat_session.clientable_type, closed: @chat_session.closed, specialist_id: @chat_session.specialist_id } }
    end

    assert_redirected_to chat_session_url(ChatSession.last)
  end

  test "should show chat_session" do
    get chat_session_url(@chat_session)
    assert_response :success
  end

  test "should get edit" do
    get edit_chat_session_url(@chat_session)
    assert_response :success
  end

  test "should update chat_session" do
    patch chat_session_url(@chat_session), params: { chat_session: { clientable_id: @chat_session.clientable_id, clientable_type: @chat_session.clientable_type, closed: @chat_session.closed, specialist_id: @chat_session.specialist_id } }
    assert_redirected_to chat_session_url(@chat_session)
  end

  test "should destroy chat_session" do
    assert_difference('ChatSession.count', -1) do
      delete chat_session_url(@chat_session)
    end

    assert_redirected_to chat_sessions_url
  end
end
