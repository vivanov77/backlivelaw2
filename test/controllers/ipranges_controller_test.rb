require 'test_helper'

class IprangesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @iprange = ipranges(:one)
  end

  test "should get index" do
    get ipranges_url
    assert_response :success
  end

  test "should get new" do
    get new_iprange_url
    assert_response :success
  end

  test "should create iprange" do
    assert_difference('Iprange.count') do
      post ipranges_url, params: { iprange: { city_id: @iprange.city_id, ip_block_end: @iprange.ip_block_end, ip_block_start: @iprange.ip_block_start, ip_range: @iprange.ip_range, kladr_city_code: @iprange.kladr_city_code } }
    end

    assert_redirected_to iprange_url(Iprange.last)
  end

  test "should show iprange" do
    get iprange_url(@iprange)
    assert_response :success
  end

  test "should get edit" do
    get edit_iprange_url(@iprange)
    assert_response :success
  end

  test "should update iprange" do
    patch iprange_url(@iprange), params: { iprange: { city_id: @iprange.city_id, ip_block_end: @iprange.ip_block_end, ip_block_start: @iprange.ip_block_start, ip_range: @iprange.ip_range, kladr_city_code: @iprange.kladr_city_code } }
    assert_redirected_to iprange_url(@iprange)
  end

  test "should destroy iprange" do
    assert_difference('Iprange.count', -1) do
      delete iprange_url(@iprange)
    end

    assert_redirected_to ipranges_url
  end
end
