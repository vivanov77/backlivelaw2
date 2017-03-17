class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :created_at, :updated_at
  has_many :comments, if: -> { should_render_comments }
  has_many :file_containers, if: -> { should_render_file_containers }  

# http://stackoverflow.com/questions/42244237/activemodel-serializers-has-many-with-condition-at-run-time
  def should_render_comments
  	@instance_options[:show_comments]
  end

  def should_render_file_containers
  	@instance_options[:show_file_containers]
  end  
end
