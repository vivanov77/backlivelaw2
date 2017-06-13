
namespace :kladr do

  desc 'Сгенерировать модели загрузки регионов и городов.'
  task metro: :environment do
    generate_models
  end  

  def generate_models

    directory = "db/geokladr"
    
    # metro_table = File.read(File.join(directory, 'hh_metro.json'))

    metro_table = File.read(File.join(directory, 'hh_metro_all.json'))

    metro_table_data = JSON.parse(metro_table,:symbolize_names => true)

    MetroLine.destroy_all

    MetroStation.destroy_all

    metro_table_data.each do |metro_city_hash|

      metroable_name = metro_city_hash[:name]

      # p metroable_name

      metroable_type = false

      metroable_id = false

      if (city = City.find_by name: metroable_name)

        metroable_type = "City"

        metroable_id = city.id

      elsif (region = Region.find_by name: metroable_name)

        metroable_type = "Region"

        metroable_id = region.id

      end

      if metroable_type

        metro_city_hash[:lines].sort_by{ |hsh| hsh[:name] }.each do |metro_line_hash|

          ml = MetroLine.find_or_create_by name: metro_line_hash[:name],
                hex_color: metro_line_hash[:hex_color], metroable_type: metroable_type,
                metroable_id: metroable_id

          stations = metro_line_hash[:stations].sort_by{ |hsh| hsh[:name] }.each do |metro_station_hash|

            # p metro_station_hash[:name]

            ms = MetroStation.find_or_create_by name: metro_station_hash[:name], metro_line_id: ml.id,
                lat: metro_station_hash[:lat], lng: metro_station_hash[:lng]

          end

        end

      end


    end

  end

end