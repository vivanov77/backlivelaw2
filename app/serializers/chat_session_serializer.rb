class ChatSessionSerializer < ActiveModel::Serializer
  attributes :id, :closed
  has_one :specialist
  has_one :clientable
end
