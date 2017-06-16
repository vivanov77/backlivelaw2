class LibEntrySerializer < ActiveModel::Serializer
  attributes :id, :title, :text, :data, :created_at, :updated_at
  has_one :lib_entry, if: -> { should_render_lib_entry }

  def should_render_lib_entry
  	@instance_options[:show_lib_entries]
  end

end
