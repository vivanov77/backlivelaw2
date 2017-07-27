module ApplicationHelper

	def api_paginate(scope, default_per_page = 20)
# https://gist.github.com/be9/6446051
	  collection = scope.page(params[:offset]).per((params[:limit] || default_per_page).to_i)

	  current, total, per_page, total_count = collection.current_page, collection.total_pages, collection.limit_value, collection.total_count

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

    # collection 

    result_collection = yield collection if block_given? 

	  return {
	    pagination: {
	      current:  current,
	      previous: (current > 1 ? (current - 1) : nil),
	      next:     (current == total ? nil : (current + 1)),
	      limit:    per_page,
	      pages:    total,
	      count:    total_count
	    },
	    result: result_collection
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

    param && param != "false" && param != "nil"

  end

  def helper_by_name2 path, id=nil, params=nil

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

# http://stackoverflow.com/questions/7994484/empty-folders-when-file-is-deleted-using-carrierwave
  def remove_file_directory uploader
    path = File.expand_path(uploader.store_path, uploader.root)
    FileUtils.remove_dir(path, force: false)
  end

  def heroku?
# http://stackoverflow.com/questions/9383450/how-can-i-detect-herokus-environment    
    Rails.env.production? && !ENV['DYNO'].blank?
  end   

  def secret_key key

    heroku? ? ENV[key] : Rails.application.secrets[key]

  end

  def uploader_name_helper instance_obj
# https://stackoverflow.com/questions/41863242/how-to-dynamically-determining-carrierwave-uploader-column-name/44179356#44179356
    instance_obj.class.try(:uploaders).try(:keys).try(:first).try(:to_sym)

  end

# https://stackoverflow.com/questions/4508692/get-available-diskspace-in-ruby
  def check_disk_space
    system('df -H | grep debug > ff')
    ss = File.open('ff').read.split(/\s+/)
    system('rm ff')
    "#{ss[3]}"
  end


  def image_stored_file_path image
# http://stackoverflow.com/questions/2733007/urldecode-in-ruby
    URI.unescape(image.file.to_s).to_s
  end

  def image_file_path image
# http://stackoverflow.com/questions/3724487/rails-root-directory-path
    Rails.root.to_s + "/public" + (image_stored_file_path image)

  end

  def obj_file_size obj

    uploader = obj.send obj.name.to_sym

    file_path = Rails.root.to_s + "/public" + URI.unescape(uploader.to_s).to_s

    number_to_human_size (File.size file_path)

  end

  def payment_name x
    name = (x.try(:name) ? (x.try(:name) + "#id:" + x.try(:id).try(:to_s)) : nil ) || 
    (x.try(:title) ? (x.try(:title) + "#id:" + x.try(:id).try(:to_s)) : nil ) || 
    (x.try(:timespan) ? (x.category.name + "#" + CategorySubscription::TIME_SPANS[x.try(:timespan).to_sym]) : nil) ||
    x.try(:doc_request).try(:title) ||
    (x.try(:proposable) ? (x.proposable.class.try(:runame) + "#" + x.name ) : nil)
  end

  def user_payment_name x
    name = (x.try(:name) ? (x.try(:name)) : nil ) || 
    x.try(:title) ||
    (x.try(:timespan) ? (x.category.name + "#" + CategorySubscription::TIME_SPANS[x.try(:timespan).to_sym]) : nil) ||
    x.try(:doc_request).try(:title) ||
    (x.try(:proposable) ? (x.proposable.class.try(:runame) + "#" + x.name ) : nil)
  end  

  def make_grouped_options params
  # https://stackoverflow.com/questions/1192843/grouped-select-in-rails

    grouped_options = {}

    params.each do |param|

      grouped_options[param.runame] = param.all.map do |x|

        name = payment_name x

        arr = []

        arr << name

        arr << "#{x.class.to_s}\##{x.id}"

        arr

      end

    end

    grouped_options

  end

  def type_id obj
    obj ? (obj.class.to_s + "#" + obj.id.to_s) : nil
  end

  class UserError < StandardError; end

  class DoubleAdminError < StandardError; end
  

  def verify_google_recptcha(secret_key,response)

    return false if response.blank?

     uri = URI('https://www.google.com/recaptcha/api/siteverify')
     res = Net::HTTP.post_form(uri, 'secret' => secret_key, 'response' => response)   
     
     hash = JSON.parse(res.body)

     hash["success"] == true ? true : false
  end

  def param2hash param
    # http://stackoverflow.com/questions/1667630/how-do-i-convert-a-string-object-into-a-hash-object
    # arr["1"]
    JSON.parse param.gsub('=>', ':') 
  end  

end