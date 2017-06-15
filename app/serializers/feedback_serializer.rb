class FeedbackSerializer < ActiveModel::Serializer
  attributes :id, :text, :name, :email, :created_at, :updated_at
  has_one :user, if: -> { should_render_user }

# http://stackoverflow.com/questions/42244237/activemodel-serializers-has-many-with-condition-at-run-time
  def should_render_user
  	@instance_options[:show_user]
  end

end
