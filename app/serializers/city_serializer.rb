class CitySerializer < ActiveModel::Serializer
  attributes :id, :kladr_code, :name, :kladr_type_short, :kladr_type, :latitude, :longitude
  has_one :region, if: -> { should_render_association }

# http://stackoverflow.com/questions/42244237/activemodel-serializers-has-many-with-condition-at-run-time
  def should_render_association
  	@instance_options[:show_parent]
  end  
end
