class ProposalSerializer < ActiveModel::Serializer
  attributes :id, :price, :limit_hours, :limit_minutes
  has_one :user, if: -> { should_render_user }

  def should_render_user
  	@instance_options[:show_user]
  end
    
end
