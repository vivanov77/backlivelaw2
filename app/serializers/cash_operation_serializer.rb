class CashOperationSerializer < ActiveModel::Serializer
  attributes :id, :operation, :sum, :comment
  has_one :user, if: -> { should_render_user }

  def should_render_user
  	@instance_options[:show_user]
  end
    
end
