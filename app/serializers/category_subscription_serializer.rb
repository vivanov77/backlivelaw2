class CategorySubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :timespan, :price, :payment_name
  has_one :category, if: -> { should_render_category }

  include ApplicationHelper

  def payment_name
  	super object
  end

  def should_render_category
    @instance_options[:show_category]
  end

end
