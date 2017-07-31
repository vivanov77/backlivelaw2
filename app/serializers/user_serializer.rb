class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :avatar, :active, :last_name, :middle_name, :email_public, :phone,
  :experience, :qualification, :price, :university, :faculty, :dob_issue, :work, :staff, :dob,
  :balance, :online, :created_at, :updated_at, :online_time, :login, :fax, :userdata, :extends
  # has_many :cities, if: -> { should_render_association }
  has_many :cities, if: -> { should_render_cities }
  has_many :roles, if: -> { should_render_roles }
  has_many :actual_purchased_category_subscriptions, if: -> { should_render_actual_purchased_category_subscriptions }
  has_many :purchased_category_subscriptions, if: -> { should_render_purchased_category_subscriptions }
  has_one :virtual_relation_distance, if: -> { should_render_virtual_relation_distance }
  has_one :virtual_relation_balance, if: -> { should_render_virtual_relation_balance }

# http://stackoverflow.com/questions/42244237/activemodel-serializers-has-many-with-condition-at-run-time
  def should_render_cities
  	@instance_options[:show_cities]
  end

  def virtual_relation_balance
    {
      nominal_balance: object.get_nominal_balance,

      frozen_balance: object.get_frozen_balance,

      accessible_balance: object.get_accessible_balance
    }
  end

  def virtual_relation_distance

    unless @instance_options[:city_id]

      return "param \"city_id\" is missing"
      
    end    

    city = City.find_by id: @instance_options[:city_id]

    unless city

      return "base city not found by id: #{@instance_options[:city_id]}"
      
    end

    unless object.try(:cities).try(:first)

      return "user city not defined"
      
    end

    unless city.try(:latitude)

      return "base city with id: #{@instance_options[:city_id]} - latitude is empty"
      
    end

    unless city.try(:longitude)

      return "base city with id: #{@instance_options[:city_id]} - longitude is empty"
      
    end

    unless city.try(:latitude)

      return "base city with id: #{@instance_options[:city_id]} - latitude is empty"
      
    end

    unless object.try(:cities).try(:first).try(:longitude)

      return "user city - longitude is empty"
      
    end

    unless object.try(:cities).try(:first).try(:latitude)

      return "user city - latitude is empty"
      
    end    

    diff_lat = object.try(:cities).try(:first).try(:latitude) - city.try(:latitude)

    diff_lon = object.try(:cities).try(:first).try(:longitude) - city.try(:longitude)

    sq_dist = diff_lat*diff_lat + diff_lon * diff_lon

    Math.sqrt sq_dist

  end  

  def should_render_roles
  	@instance_options[:show_roles]
  end

  def should_render_actual_purchased_category_subscriptions
    @instance_options[:show_actual_purchased_category_subscriptions]
  end

  def should_render_purchased_category_subscriptions
    @instance_options[:show_purchased_category_subscriptions]
  end

  def should_render_virtual_relation_distance
    @instance_options[:show_virtual_relation_distance]
  end

  def should_render_virtual_relation_balance
    @instance_options[:show_virtual_relation_balance]
  end
    
end