require 'test_helper'

class ChatTemplatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @chat_template = chat_templates(:one)
  end

  test "should get index" do
    get chat_templates_url
    assert_response :success
  end

  test "should get new" do
    get new_chat_template_url
    assert_response :success
  end

  test "should create chat_template" do
    assert_difference('ChatTemplate.count') do
      post chat_templates_url, params: { chat_template: { text: @chat_template.text, user_id: @chat_template.user_id } }
    end

    assert_redirected_to chat_template_url(ChatTemplate.last)
  end

  test "should show chat_template" do
    get chat_template_url(@chat_template)
    assert_response :success
  end

  test "should get edit" do
    get edit_chat_template_url(@chat_template)
    assert_response :success
  end

  test "should update chat_template" do
    patch chat_template_url(@chat_template), params: { chat_template: { text: @chat_template.text, user_id: @chat_template.user_id } }
    assert_redirected_to chat_template_url(@chat_template)
  end

  test "should destroy chat_template" do
    assert_difference('ChatTemplate.count', -1) do
      delete chat_template_url(@chat_template)
    end

    assert_redirected_to chat_templates_url
  end
end
