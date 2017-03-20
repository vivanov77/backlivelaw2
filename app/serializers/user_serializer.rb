class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :active, :last_name, :middle_name, :email_public, :phone,
  :experience, :qualification, :price, :university, :faculty, :dob_issue, :work, :staff, :dob, :balance
  # has_many :cities, if: -> { should_render_association }
  has_many :cities, if: -> { should_render_cities }
  has_many :roles, if: -> { should_render_roles }

# http://stackoverflow.com/questions/42244237/activemodel-serializers-has-many-with-condition-at-run-time
  def should_render_cities
  	@instance_options[:show_cities]
  end

  def should_render_roles
  	@instance_options[:show_roles]
  end
    
end