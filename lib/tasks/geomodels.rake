
namespace :kladr do

  desc 'Сгенерировать модели загрузки регионов и городов.'
  task mod: :environment do
    generate_models
  end  

  def generate_models

    tmp_directory = "db/geokladr/tmp"
    directory = "db/geokladr"

    ip_table = File.read(File.join(tmp_directory, 'ip_table.json'))
# http://stackoverflow.com/questions/1732001/what-is-the-best-way-to-convert-a-json-formated-key-value-pair-to-ruby-hash-with
    ip_table_data = JSON.parse(ip_table,:symbolize_names => true)

    cities = []
    regions = []
    ip_ranges = []    

    ip_table_data.each do |ip_entry_hash|

      city = {}

      city[:kladr_code] = ip_entry_hash[:kladr_code]
      city[:name] = ip_entry_hash[:ip_kladr_name]
      city[:type_short] = ip_entry_hash[:kladr_type_short]
      city[:type] = ip_entry_hash[:kladr_type]

      city[:ip_lat] = ip_entry_hash[:ip_lat]
      city[:ip_lon] = ip_entry_hash[:ip_lon]

      city_found = (cities.select {|hash| hash[:name] == city[:name] }).first
      unless city_found

        cities << city

        p city[:name]

      end

      region = {}

      region[:kladr_code] = ip_entry_hash[:kladr_region_code]
      region[:name] = ip_entry_hash[:kladr_region_name]
      region[:type_short] = ip_entry_hash[:kladr_region_type_short]
      region[:type] = ip_entry_hash[:kladr_region_type] 

      region_found = (regions.select {|hash| hash[:name] == region[:name] }).first
      unless region_found

        regions << region

        p region[:name]

      end

      ip_range = {}

      ip_range[:ip_block_start] = ip_entry_hash[:ip_block_start]
      ip_range[:ip_block_end] = ip_entry_hash[:ip_block_end]
      ip_range[:ip_range] = ip_entry_hash[:ip_range]
      ip_range[:kladr_city_code] = ip_entry_hash[:kladr_code]

      ip_range_found = (ip_ranges.select {|hash| hash[:ip_block_start] == ip_range[:ip_block_start] }).first
      unless ip_range_found

        ip_ranges << ip_range

        p ip_entry_hash[:ip_kladr_name]

      end      

    end

    cities = cities.sort_by { |hsh| hsh[:name] }

    File.open(File.join(directory, 'cities.json'), 'w+') do |f|

      f.puts JSON.pretty_generate(cities)

    end

    regions = regions.sort_by { |hsh| hsh[:name] }

    File.open(File.join(directory, 'regions.json'), 'w+') do |f|

      f.puts JSON.pretty_generate(regions)

    end

    ip_ranges = ip_ranges.sort_by { |hsh| hsh[:ip_block_start] }

    File.open(File.join(directory, 'ip_ranges.json'), 'w+') do |f|

      f.puts JSON.pretty_generate(ip_ranges)

    end

  end
end