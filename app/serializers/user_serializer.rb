class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :active, :last_name, :middle_name, :email_public, :phone,
  :experience, :qualification, :price, :university, :faculty, :dob_issue, :work, :staff, :dob,
  :balance, :online,
  :created_at, :updated_at, :online_time, :login, :fax, :userdata, :extends
  # has_many :cities, if: -> { should_render_association }
  has_many :cities, if: -> { should_render_cities }
  has_many :roles, if: -> { should_render_roles }
  has_many :actual_purchased_categories, if: -> { should_render_actual_purchased_categories }
  has_many :purchased_categories, if: -> { should_render_purchased_categories }  

# http://stackoverflow.com/questions/42244237/activemodel-serializers-has-many-with-condition-at-run-time
  def should_render_cities
  	@instance_options[:show_cities]
  end

  def should_render_roles
  	@instance_options[:show_roles]
  end

  def should_render_actual_purchased_categories
    @instance_options[:show_actual_purchased_categories]
  end

  def should_render_purchased_categories
    @instance_options[:show_purchased_categories]
  end  
    
end