require 'test_helper'

class DocRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @doc_request = doc_requests(:one)
  end

  test "should get index" do
    get doc_requests_url
    assert_response :success
  end

  test "should get new" do
    get new_doc_request_url
    assert_response :success
  end

  test "should create doc_request" do
    assert_difference('DocRequest.count') do
      post doc_requests_url, params: { doc_request: { paid: @doc_request.paid, text: @doc_request.text, title: @doc_request.title, user_id: @doc_request.user_id } }
    end

    assert_redirected_to doc_request_url(DocRequest.last)
  end

  test "should show doc_request" do
    get doc_request_url(@doc_request)
    assert_response :success
  end

  test "should get edit" do
    get edit_doc_request_url(@doc_request)
    assert_response :success
  end

  test "should update doc_request" do
    patch doc_request_url(@doc_request), params: { doc_request: { paid: @doc_request.paid, text: @doc_request.text, title: @doc_request.title, user_id: @doc_request.user_id } }
    assert_redirected_to doc_request_url(@doc_request)
  end

  test "should destroy doc_request" do
    assert_difference('DocRequest.count', -1) do
      delete doc_request_url(@doc_request)
    end

    assert_redirected_to doc_requests_url
  end
end
