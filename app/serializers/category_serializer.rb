class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :category_subscriptions
end
