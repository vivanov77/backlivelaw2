class CommentSerializer < ActiveModel::Serializer
  attributes :id, :title
  has_one :user
  has_one :response
end
