# encoding: utf-8
namespace :kladr do

  desc 'Сгенерировать json-файл загрузки ip-адресов. Параметр - путь к папке geo_files.'
  # Синтаксис: rake kladr:ip["/home/viktor/geo_files"]
  # geo-files взято с http://ipgeobase.ru/
  task :ip, [:ip_folder_path] => [:environment] do |t, args|
    generate_ip_table args
  end

  def generate_ip_table args

    path = args[:ip_folder_path]

    cidr_optim_path = path + "/cidr_optim.txt"

    cities_path = path + "/cities.txt"

    tmp_directory = "db/geokladr/tmp"
    directory = "db/geokladr"
    arc_directory = "db/geokladr/archive"    

# https://hackhands.com/ruby-read-json-file-hash/
    kladr_regions = File.read(File.join(tmp_directory, 'kladr_regions.json'))

# http://stackoverflow.com/questions/1732001/what-is-the-best-way-to-convert-a-json-formated-key-value-pair-to-ruby-hash-with
    kladr_regions_data = JSON.parse(kladr_regions,:symbolize_names => true)

    kladr_cities = File.read(File.join(tmp_directory, 'kladr_cities.json'))
# http://stackoverflow.com/questions/1732001/what-is-the-best-way-to-convert-a-json-formated-key-value-pair-to-ruby-hash-with
    kladr_cities_data = JSON.parse(kladr_cities,:symbolize_names => true)

    kladr_cities2 = File.read(File.join(tmp_directory, 'kladr_cities2.json'))
# http://stackoverflow.com/questions/1732001/what-is-the-best-way-to-convert-a-json-formated-key-value-pair-to-ruby-hash-with
    kladr_cities2_data = JSON.parse(kladr_cities2,:symbolize_names => true)

    kladr_cities3 = File.read(File.join(tmp_directory, 'kladr_cities3.json'))
# http://stackoverflow.com/questions/1732001/what-is-the-best-way-to-convert-a-json-formated-key-value-pair-to-ruby-hash-with
    kladr_cities3_data = JSON.parse(kladr_cities3,:symbolize_names => true)

    kladr_cities4 = File.read(File.join(tmp_directory, 'kladr_cities4.json'))
# http://stackoverflow.com/questions/1732001/what-is-the-best-way-to-convert-a-json-formated-key-value-pair-to-ruby-hash-with
    kladr_cities4_data = JSON.parse(kladr_cities4,:symbolize_names => true)    


    cities = []

    diff_cities = []    

    p "Reading the list of cities..."

    File.open(cities_path, "r") do |f|
      f.each_line do |line|

  # http://stackoverflow.com/questions/16499055/from-windows-1251-to-utf-8-ruby-on-rails
        converted_line = line.force_encoding("cp1251").encode("utf-8", undef: :replace)

        data = converted_line.split(/\t/)

# http://stackoverflow.com/questions/7378069/rails-how-to-downcase-non-english-string
        unless data[3].to_s.mb_chars.downcase.to_s.include? "украина"

          city = {}

          city[:ip_code] = data[0]
          city[:ip_name] = data[1]
          city[:ip_region] = data[2]

          city[:ip_lat] = data[4]
  # http://stackoverflow.com/questions/4209384/ruby-remove-last-n-characters-from-a-string
          city[:ip_lon] = data[5].chomp

          cities << city

          # p city[:name]

        end

      end
    end

    # return

    ip_table = []

    File.open(cidr_optim_path, "r") do |f|
      f.each_line do |line|
        data = line.split(/\t/)

        if data[4] != "-\n" && data[3] != "UA"

  # http://stackoverflow.com/questions/4209384/ruby-remove-last-n-characters-from-a-string
          city_code = data[4].chomp

  # http://stackoverflow.com/questions/2244915/how-do-i-search-within-an-array-of-hashes-by-hash-values-in-ruby
          city = (cities.select {|hash| hash[:ip_code] == city_code }).first

    # http://stackoverflow.com/questions/2244915/how-do-i-search-within-an-array-of-hashes-by-hash-values-in-ruby
          kladr_city = (kladr_cities_data.select {|hash| hash[:name] == city[:ip_name] }).first
          kladr_city2 = (kladr_cities2_data.select {|hash| hash[:name] == city[:ip_name] }).first
          kladr_city3 = (kladr_cities3_data.select {|hash| hash[:name] == city[:name] }).first          
          kladr_city4 = (kladr_cities4_data.select {|hash| hash[:name] == city[:ip_name] }).first

          kladr_entry = kladr_city || kladr_city2  || kladr_city3 || kladr_city4

          if kladr_entry && kladr_entry[:type] == "Город"

            ip_entry = {}

            ip_entry[:ip_block_start] = data[0]
            ip_entry[:ip_block_end] = data[1]
            ip_entry[:ip_range] = data[2]
            ip_entry[:ip_kladr_name] = city[:ip_name]
            ip_entry[:ip_region] = city[:ip_region]

            ip_entry[:kladr_code] = kladr_entry[:code]
            ip_entry[:kladr_type_short] = kladr_entry[:type_short]
            ip_entry[:kladr_type] = kladr_entry[:type]

            kladr_region_code = kladr_entry[:code].slice(0..1)
            diff_kladr_region = (kladr_regions_data.select {|hash| hash[:code] == kladr_region_code }).first
            if diff_kladr_region
              ip_entry[:kladr_region_code] = diff_kladr_region[:code] + "000000000"
              ip_entry[:kladr_region_name] = diff_kladr_region[:name]
              ip_entry[:kladr_region_type_short] = diff_kladr_region[:type_short]
              ip_entry[:kladr_region_type] = diff_kladr_region[:type]
            end

            ip_entry[:ip_lat] = city[:ip_lat]

            ip_entry[:ip_lon] = city[:ip_lon]

            ip_table << ip_entry

            p ip_entry[:ip_kladr_name]

          else
            diff_city_found = (diff_cities.select {|hash| hash[:ip_name] == city[:ip_name] }).first
            unless diff_city_found

              diff_city = {}

              diff_city[:ip_code] = city[:ip_code]
              diff_city[:ip_name] = city[:ip_name]
              diff_city[:ip_region] = city[:ip_region]

              # city3_found = (kladr_cities3_data.select {|hash| hash[:name] == diff_city[:ip_name] }).first

              # if city3_found
              #   diff_city[:kladr_code] = city3_found[:code]
              #   diff_city[:kladr_type_short] = city3_found[:type_short]
              #   diff_city[:kladr_type] = city3_found[:type]
              #   diff_city[:kladr_zip] = city3_found[:zip] if city3_found[:zip]

              #   kladr_region_code = city3_found[:code].slice(0..1)
              #   diff_kladr_region = (kladr_regions_data.select {|hash| hash[:code] == kladr_region_code }).first
              #   diff_city[:kladr_region] = diff_kladr_region[:name] if diff_kladr_region

              # end

              diff_cities << diff_city
            end
          end

        end
      end
    end


# http://stackoverflow.com/questions/36350321/errnoenoent-no-such-file-or-directory-rb-sysopen
    FileUtils.mkdir_p(directory) unless File.exist?(directory)

    ip_table = ip_table.sort_by { |hsh| hsh[:ip_kladr_name] }

    File.open(File.join(tmp_directory, 'ip_table.json'), 'w+') do |f|

      # f.puts result.to_json
      f.puts JSON.pretty_generate(ip_table)

    end

    if diff_cities.size > 0

      diff_cities = diff_cities.sort_by { |hsh| hsh[:ip_name] }

# http://stackoverflow.com/questions/36350321/errnoenoent-no-such-file-or-directory-rb-sysopen
      FileUtils.mkdir_p(arc_directory) unless File.exist?(arc_directory)

      File.open(File.join(arc_directory, 'diff_cities.json'), 'w+') do |f|

        # f.puts result.to_json
        f.puts JSON.pretty_generate(diff_cities)

      end

    end

 
  end
end