class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :category_subscriptions, if: -> { should_render_category_subscriptions }

  def should_render_category_subscriptions
    @instance_options[:show_category_subscriptions]
  end

end