json.extract! city, :id, :kladr_code, :name, :kladr_type_short, :kladr_type, :latitude, :longitude, :region_id, :created_at, :updated_at
json.url city_url(city, format: :json)