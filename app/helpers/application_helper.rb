module ApplicationHelper

	def api_paginate(scope, default_per_page = 20)
# https://gist.github.com/be9/6446051
	  collection = scope.page(params[:offset]).per((params[:limit] || default_per_page).to_i)

	  current, total, per_page = collection.current_page, collection.total_pages, collection.limit_value

	  # return [{
	  #   pagination: {
	  #     current:  current,
	  #     previous: (current > 1 ? (current - 1) : nil),
	  #     next:     (current == total ? nil : (current + 1)),
	  #     limit:    per_page,
	  #     pages:    total,
	  #     count:    collection.total_count
	  #   }
	  # }, {result: collection}]

	  return {
	    pagination: {
	      current:  current,
	      previous: (current > 1 ? (current - 1) : nil),
	      next:     (current == total ? nil : (current + 1)),
	      limit:    per_page,
	      pages:    total,
	      count:    collection.total_count
	    },
	    result: collection
	  }	  
	end

  # def class_by_name name
  #   # http://stackoverflow.com/questions/14070369/how-to-instantiate-class-from-name-string-in-rails
  #   Object.const_get name.to_s.capitalize

  # end

  def class_by_name name
    # http://stackoverflow.com/questions/14070369/how-to-instantiate-class-from-name-string-in-rails
    Object.const_get name.to_s

  end  

########################
  def seed_regions

    Region.destroy_all

    kladr_path ="db/geokladr"

    regions_path = "regions.json"

 
    unless File.exist?(Rails.root + File.join(kladr_path, regions_path))

      p "File \"" + File.join(kladr_path, regions_path) + "\" not found, kladr is not loaded."

      return

    end

    regions = File.read(Rails.root + File.join(kladr_path, regions_path))
# http://stackoverflow.com/questions/1732001/what-is-the-best-way-to-convert-a-json-formated-key-value-pair-to-ruby-hash-with
    regions = JSON.parse(regions,:symbolize_names => true)

    regions.each do |hash|

      h = {}

      h[:kladr_code] = hash[:kladr_code]
      h[:name] = hash[:name]
      h[:kladr_type_short] = hash[:type_short]
      h[:kladr_type] = hash[:type]

      region = Region.new h

      region.save!

      p "region: " + h[:name]

    end  

  end

#############################3

  def seed_cities

    City.destroy_all

    kladr_path ="db/geokladr" 

    cities_path = "cities.json"

    unless File.exist? Rails.root.join(kladr_path, cities_path)

      p "File \"" + File.join(kladr_path, cities_path) + "\" not found, kladr is not loaded."

      return

    end  

    cities = File.read(Rails.root + File.join(kladr_path, cities_path))
# http://stackoverflow.com/questions/1732001/what-is-the-best-way-to-convert-a-json-formated-key-value-pair-to-ruby-hash-with
    cities = JSON.parse(cities,:symbolize_names => true) 

    cities.each_with_index do |hash,index|

      h = {}

      h[:kladr_code] = hash[:kladr_code]
      h[:name] = hash[:name]
      h[:kladr_type_short] = hash[:type_short]
      h[:kladr_type] = hash[:type]
      h[:latitude] = hash[:ip_lat].to_f
      h[:longitude] = hash[:ip_lon].to_f

      region_code = hash[:kladr_code].slice(0..1) + "000000000"

      region = Region.find_by(kladr_code: region_code)

      if region

        region.cities.create h

        p "city: " + h[:name]

      else

        p "Region with kladr_code \"#{hash[:kladr_code]}\" is not found"

      end

      # break if index==10

    end  

  end

#################################

  def seed_ipranges

    Iprange.destroy_all

    kladr_path ="db/geokladr"

    ip_ranges_path = "ip_ranges.json"


    unless File.exist?(Rails.root + File.join(kladr_path, ip_ranges_path))

      p "File \"" + File.join(kladr_path, ip_ranges_path) + "\" not found, kladr is not loaded."

      return      

    end

    ip_ranges = File.read(Rails.root + File.join(kladr_path, ip_ranges_path))
# http://stackoverflow.com/questions/1732001/what-is-the-best-way-to-convert-a-json-formated-key-value-pair-to-ruby-hash-with
    ip_ranges = JSON.parse(ip_ranges,:symbolize_names => true)

    ip_ranges.each do |hash|

      h = {}

      h[:ip_block_start] = hash[:ip_block_start].to_i
      h[:ip_block_end] = hash[:ip_block_end].to_i
      h[:ip_range] = hash[:ip_range]
   

      city_code = hash[:kladr_city_code]

      city = City.find_by(kladr_code: city_code)

      if city

        city.ipranges.create h

        p "iprange: " + h[:ip_block_start].to_s

      else

        p "City with kladr_code \"#{hash[:kladr_code]}\" is not found"

      end

      # break if index==10      

    end

  end

#################################

# http://guides.rubyonrails.org/active_record_validations.html#performing-custom-validations
  class SingleCityValidator < ActiveModel::Validator
    def validate(record)
      if record.cities.size > 1

        record.errors["errors"] << "У пользователя может быть только один город."

      end
    end
  end

  def ru_action name

    case name.to_s
    when "create"
    "создание"      
    when "edit"
    "редактирование"
    when "new"
    "создание"
    when "destroy"
    "удаление"
    when "show"
    "просмотр"
    when "index"
    "просмотр списка"    
    else
    "внесение измений"
    end
  end

  def param? param

    (!(param == "false") && !(param == "nil") && param)

  end


  def helper_by_name2 path, id, params

    Rails.application.routes.url_helpers.send path, id, params

  end

  def submit_russian_text rus_model_name

    if action_name == "new"

      "Создать " + rus_model_name

    elsif action_name == "edit"

      "Сохранить " + rus_model_name      

    end

  end

  def doubled_signed_token string1, string2

    token = (string1 >= string2) ? (string1 + string2) : (string2 + string1)

    signed_token token

  end

  def signed_token string1

    token = string1

# http://vesavanska.com/2013/signing-and-encrypting-data-with-tools-built-in-to-rails

    secret_key_base = Rails.application.secrets.secret_key_base

    verifier = ActiveSupport::MessageVerifier.new secret_key_base

    signed_token1 = verifier.generate token

    pos = signed_token1.index('--') + 2

    signed_token1.slice pos..-1

  end

  def generate_unique_secure_token
    SecureRandom.base58(24)
  end  
	
end