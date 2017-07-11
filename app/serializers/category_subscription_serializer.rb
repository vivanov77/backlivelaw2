class CategorySubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :timespan, :price, :payment_name
  has_one :category

  include ApplicationHelper

  def payment_name
  	super object
  end
end
