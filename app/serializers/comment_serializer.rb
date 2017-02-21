class CommentSerializer < ActiveModel::Serializer
  attributes :id, :title, :created_at, :updated_at
  has_many :comments, if: -> { should_render_association }

# http://stackoverflow.com/questions/42244237/activemodel-serializers-has-many-with-condition-at-run-time
  def should_render_association
  	@instance_options[:show_children]
  end
end
