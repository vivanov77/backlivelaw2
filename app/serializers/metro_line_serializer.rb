class MetroLineSerializer < ActiveModel::Serializer
  attributes :id, :name, :hex_color, :metroable_type, :metroable_id

  has_many :metro_stations, if: -> { should_render_metro_stations }

  def should_render_metro_stations
  	@instance_options[:show_metro_stations]
  end  

end
