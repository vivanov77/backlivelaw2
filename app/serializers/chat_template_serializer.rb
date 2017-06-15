class ChatTemplateSerializer < ActiveModel::Serializer
  attributes :id, :text
  has_one :user
end
