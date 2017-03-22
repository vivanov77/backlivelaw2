require 'test_helper'

class DocResponsesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @doc_response = doc_responses(:one)
  end

  test "should get index" do
    get doc_responses_url
    assert_response :success
  end

  test "should get new" do
    get new_doc_response_url
    assert_response :success
  end

  test "should create doc_response" do
    assert_difference('DocResponse.count') do
      post doc_responses_url, params: { doc_response: { chosen: @doc_response.chosen, doc_request_id: @doc_response.doc_request_id, price: @doc_response.price, text: @doc_response.text, user_id: @doc_response.user_id } }
    end

    assert_redirected_to doc_response_url(DocResponse.last)
  end

  test "should show doc_response" do
    get doc_response_url(@doc_response)
    assert_response :success
  end

  test "should get edit" do
    get edit_doc_response_url(@doc_response)
    assert_response :success
  end

  test "should update doc_response" do
    patch doc_response_url(@doc_response), params: { doc_response: { chosen: @doc_response.chosen, doc_request_id: @doc_response.doc_request_id, price: @doc_response.price, text: @doc_response.text, user_id: @doc_response.user_id } }
    assert_redirected_to doc_response_url(@doc_response)
  end

  test "should destroy doc_response" do
    assert_difference('DocResponse.count', -1) do
      delete doc_response_url(@doc_response)
    end

    assert_redirected_to doc_responses_url
  end
end
