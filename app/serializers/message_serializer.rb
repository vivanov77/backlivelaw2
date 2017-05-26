class MessageSerializer < ActiveModel::Serializer
  attributes :id, :text, :read, :spam, :created_at, :updated_at
  has_one :sender
  has_one :recipient
end
