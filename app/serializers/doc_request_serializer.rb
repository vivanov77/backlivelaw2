class DocRequestSerializer < ActiveModel::Serializer
  attributes :id, :title, :text, :created_at, :updated_at
  has_one :user, if: -> { should_render_user }
  has_many :doc_responses, if: -> { should_render_responses }
  has_many :categories, if: -> { should_render_categories }
  has_many :proposals, if: -> { should_render_proposals }
  has_one :virtual_relation_payment, if: -> { should_render_virtual_relation_payment }

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

  def should_render_proposals
    @instance_options[:show_proposals]
  end 

  def should_render_virtual_relation_payment
    @instance_options[:show_virtual_relation_payment]
  end
  
end
