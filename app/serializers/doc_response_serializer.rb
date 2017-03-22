class DocResponseSerializer < ActiveModel::Serializer
  attributes :id, :chosen, :text, :price, :created_at, :updated_at
  # has_one :user
  # has_one :doc_request
  has_many :file_containers, if: -> { should_render_file_containers }

  def should_render_file_containers
  	@instance_options[:show_file_containers]
  end
  
end
