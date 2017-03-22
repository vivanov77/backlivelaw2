class DocRequestSerializer < ActiveModel::Serializer
  attributes :id, :title, :text, :paid, :created_at, :updated_at
  has_one :user, if: -> { should_render_user }
  has_many :doc_responses, if: -> { should_render_responses }
  has_many :categories, if: -> { should_render_categories }

# http://stackoverflow.com/questions/42244237/activemodel-serializers-has-many-with-condition-at-run-time
  def should_render_user
  	@instance_options[:show_user]
  end

# http://stackoverflow.com/questions/42244237/activemodel-serializers-has-many-with-condition-at-run-time
  def should_render_responses
  	@instance_options[:show_responses]
  end

    # http://stackoverflow.com/questions/42244237/activemodel-serializers-has-many-with-condition-at-run-time
  def should_render_categories
  	@instance_options[:show_categories]
  end
end
