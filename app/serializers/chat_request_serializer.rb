class ChatRequestSerializer < ActiveModel::Serializer
  attributes :id, :guest_login, :guest_password
end
