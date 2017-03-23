class LibEntrySerializer < ActiveModel::Serializer
  attributes :id, :title, :text
  has_one :lib_entry
end
