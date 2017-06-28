class CitySerializer < ActiveModel::Serializer
  attributes :id, :kladr_code, :name, :kladr_type_short, :kladr_type, :latitude, :longitude
  has_one :region, if: -> { should_render_association }
  has_many :metro_lines, if: -> { should_render_metro_lines }

# http://stackoverflow.com/questions/42244237/activemodel-serializers-has-many-with-condition-at-run-time
  def should_render_association
  	@instance_options[:show_parent]
  end

  def should_render_metro_lines
  	@instance_options[:show_metro_lines]
  end
    
end
