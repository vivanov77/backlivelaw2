
namespace :kladr do

  desc 'Сгенерировать json-файл загрузки регионов и городов. Параметр - путь к папке KLADR.'
  # Синтаксис: rake kladr:gl["/home/viktor/KLADR"]
  task :gl, [:kladr_folder_path] => [:environment] do |t, args|
    generate_list args
  end

  def generate_list args

    require 'dbf'

    path = args[:kladr_folder_path]

    socrbase_path = path + "/SOCRBASE.DBF"

    kladr_path = path + "/KLADR.DBF"

    socrbase_dbf = DBF::Table.new(socrbase_path, nil, 'cp866')

    kladr_dbf = DBF::Table.new(kladr_path, nil, 'cp866')

    socrbase = []

    socrbase_dbf.each_with_index do |record,index|

      scname = record['SCNAME']

      socrname = record['SOCRNAME']

      socr = {}

      socr[:type_short] = scname

      socr[:type] = socrname

      socrbase << socr

    end

    # result = []

# Структура кодового обозначения в блоке "Код":
# СС РРР ГГГ ППП АА, где
# СС – код субъекта Российской Федерации (региона), коды регионов представлены в Приложении 2 к Описанию классификатора адресов Российской Федерации (КЛАДР);
# РРР – код района;
# ГГГ – код города;      
# ППП – код населенного пункта,

    regions = []     # СС 000 000 000
    cities = []      # СС 000 ГГГ 000
    cities2 = []   # СС РРР ГГГ 000 Туапсе
    # subregions = []  # СС РРР 000 000
    cities3 = [] # СС РРР 000 ППП
    cities4 = []   # СС 000 ГГГ ППП Алупка

    kladr_dbf.each_with_index do |record,index|

      name = record['NAME']
      abbr = record['SOCR']      
      code = record['CODE']
      zip = record['INDEX']
      capital = record['STATUS']

      region_code1    = code.slice(0..1)
      subregion_code2 = code.slice(2..4)
      city_code3      = code.slice(5..7)
      town_code4      = code.slice(8..10)

      active_code     = code.slice(-2..-1)      

      city_code   = city_code3      

      if active_code == "00" # only active entries and only cities

        if code.slice(2..-1) == "00000000000" # only regions

          p name

          region = {}

          region[:code] = region_code1

          region[:name] = name
          
          region[:type_short] = abbr

# http://stackoverflow.com/questions/2244915/how-do-i-search-within-an-array-of-hashes-by-hash-values-in-ruby
          region[:type] = (socrbase.select {|hash| hash[:type_short] == abbr }).first[:type]

          region[:zip] = zip unless zip.blank?

          # result << region
          regions << region

        end

        if abbr == "г"

          if subregion_code2 == "000" &&
          city_code3 != "000" &&
          town_code4 == "000" # only cities СС 000 ГГГ 000

            p name        

            city = {}

            city[:code] = region_code1 + "000" + city_code3 + "000"

            city[:name] = name
            
            city[:type_short] = abbr

  # http://stackoverflow.com/questions/2244915/how-do-i-search-within-an-array-of-hashes-by-hash-values-in-ruby
            city[:type] = (socrbase.select {|hash| hash[:type_short] == abbr }).first[:type]

            city[:zip] = zip unless zip.blank?

  # # http://stackoverflow.com/questions/2244915/how-do-i-search-within-an-array-of-hashes-by-hash-values-in-ruby
  #           parent = (result.select {|hash| hash[:code] == region_code1 }).first

  #           parent[:children] = [] unless parent[:children]

  #           parent[:children] << city
            
            cities << city

          end

          if subregion_code2 != "000" &&
          city_code3 != "000" &&
          town_code4 == "000" # only cities2 СС РРР ГГГ 000

            p name        

            city2 = {}

            city2[:code] = region_code1 + subregion_code2 + city_code3 + "000"

            city2[:name] = name
            
            city2[:type_short] = abbr

  # http://stackoverflow.com/questions/2244915/how-do-i-search-within-an-array-of-hashes-by-hash-values-in-ruby
            city2[:type] = (socrbase.select {|hash| hash[:type_short] == abbr }).first[:type]

            city2[:zip] = zip unless zip.blank?
            
            cities2 << city2

          end

  #         if subregion_code2 != "000" &&
  #         code.slice(5..10) == "000000" # only subregions # СС РРР 000 000

  #           p name        

  #           subregion = {}

  #           region_code1 = code.slice(0..1)
  #           subregion_code1 = subregion_code2
  #           city2_code   = "000"

  #           subregion[:code] = region_code1 + subregion_code1 + city2_code

  #           subregion[:name] = name
            
  #           subregion[:type_short] = abbr

  # # http://stackoverflow.com/questions/2244915/how-do-i-search-within-an-array-of-hashes-by-hash-values-in-ruby
  #           subregion[:type] = (socrbase.select {|hash| hash[:type_short] == abbr }).first[:type]

  #           subregion[:zip] = zip unless zip.blank?

  #           subregions << subregion

  #         end

          if subregion_code2 != "000" &&
          city_code3 == "000" &&
          town_code4 != "000" # only cities3 # СС РРР 000 ППП

            p name        

            city3 = {}

            city3[:code] = region_code1 + subregion_code2 + "000" + city_code3

            city3[:name] = name
            
            city3[:type_short] = abbr

  # http://stackoverflow.com/questions/2244915/how-do-i-search-within-an-array-of-hashes-by-hash-values-in-ruby
            city3[:type] = (socrbase.select {|hash| hash[:type_short] == abbr }).first[:type]

            city3[:zip] = zip unless zip.blank?
            
            cities3 << city3

          end

          if subregion_code2 == "000" &&
          city_code3 != "000" &&
          town_code4 != "000" # only cities4 СС 000 ГГГ ППП

            p name        

            city4 = {}

            city4[:code] = region_code1 + "000" + city_code3 + town_code4

            city4[:name] = name
            
            city4[:type_short] = abbr

  # http://stackoverflow.com/questions/2244915/how-do-i-search-within-an-array-of-hashes-by-hash-values-in-ruby
            city4[:type] = (socrbase.select {|hash| hash[:type_short] == abbr }).first[:type]

            city4[:zip] = zip unless zip.blank?
            
            cities4 << city4

          end 

        end

      end

      # break if index==100
    end

    directory = "db/geokladr/tmp"

# http://stackoverflow.com/questions/36350321/errnoenoent-no-such-file-or-directory-rb-sysopen
    FileUtils.mkdir_p(directory) unless File.exist?(directory)

    regions = regions.sort_by { |hsh| hsh[:name] }
    cities =  cities.sort_by { |hsh| hsh[:name] }
    cities2 = cities2.sort_by { |hsh| hsh[:name] }
    # subregions = subregions.sort_by { |hsh| hsh[:name] }
    cities3 = cities3.sort_by { |hsh| hsh[:name] }
    cities4 = cities4.sort_by { |hsh| hsh[:name] }

    File.open(File.join(directory, 'kladr_regions.json'), 'w+') do |f|

      # f.puts result.to_json
      f.puts JSON.pretty_generate(regions)

    end

    File.open(File.join(directory, 'kladr_cities.json'), 'w+') do |f|

      f.puts JSON.pretty_generate(cities)

    end

    File.open(File.join(directory, 'kladr_cities2.json'), 'w+') do |f|

      f.puts JSON.pretty_generate(cities2)

    end

    # File.open(File.join(directory, 'kladr_subregions.json'), 'w+') do |f|

    #   f.puts JSON.pretty_generate(subregions)

    # end

    File.open(File.join(directory, 'kladr_cities3.json'), 'w+') do |f|

      f.puts JSON.pretty_generate(cities3)

    end

    File.open(File.join(directory, 'kladr_cities4.json'), 'w+') do |f|

      f.puts JSON.pretty_generate(cities4)

    end      
   
  end
end