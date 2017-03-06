require 'test_helper'

class CitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @city = cities(:one)
  end

  test "should get index" do
    get cities_url
    assert_response :success
  end

  test "should get new" do
    get new_city_url
    assert_response :success
  end

  test "should create city" do
    assert_difference('City.count') do
      post cities_url, params: { city: { kladr_code: @city.kladr_code, kladr_type: @city.kladr_type, kladr_type_short: @city.kladr_type_short, latitude: @city.latitude, longitude: @city.longitude, name: @city.name, region_id: @city.region_id } }
    end

    assert_redirected_to city_url(City.last)
  end

  test "should show city" do
    get city_url(@city)
    assert_response :success
  end

  test "should get edit" do
    get edit_city_url(@city)
    assert_response :success
  end

  test "should update city" do
    patch city_url(@city), params: { city: { kladr_code: @city.kladr_code, kladr_type: @city.kladr_type, kladr_type_short: @city.kladr_type_short, latitude: @city.latitude, longitude: @city.longitude, name: @city.name, region_id: @city.region_id } }
    assert_redirected_to city_url(@city)
  end

  test "should destroy city" do
    assert_difference('City.count', -1) do
      delete city_url(@city)
    end

    assert_redirected_to cities_url
  end
end
