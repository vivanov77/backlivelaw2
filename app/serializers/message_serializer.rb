class MessageSerializer < ActiveModel::Serializer
  attributes :id, :text, :read, :created_at, :updated_at
  has_one :sender
  has_one :recipient
end
