require 'test_helper'

class LibEntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lib_entry = lib_entries(:one)
  end

  test "should get index" do
    get lib_entries_url
    assert_response :success
  end

  test "should get new" do
    get new_lib_entry_url
    assert_response :success
  end

  test "should create lib_entry" do
    assert_difference('LibEntry.count') do
      post lib_entries_url, params: { lib_entry: { lib_entry_id: @lib_entry.lib_entry_id, text: @lib_entry.text, title: @lib_entry.title } }
    end

    assert_redirected_to lib_entry_url(LibEntry.last)
  end

  test "should show lib_entry" do
    get lib_entry_url(@lib_entry)
    assert_response :success
  end

  test "should get edit" do
    get edit_lib_entry_url(@lib_entry)
    assert_response :success
  end

  test "should update lib_entry" do
    patch lib_entry_url(@lib_entry), params: { lib_entry: { lib_entry_id: @lib_entry.lib_entry_id, text: @lib_entry.text, title: @lib_entry.title } }
    assert_redirected_to lib_entry_url(@lib_entry)
  end

  test "should destroy lib_entry" do
    assert_difference('LibEntry.count', -1) do
      delete lib_entry_url(@lib_entry)
    end

    assert_redirected_to lib_entries_url
  end
end
