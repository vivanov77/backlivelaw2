class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :created_at, :updated_at
  has_many :responses if false
  # has_many :responses

  # def include_responses?
  #   false
  # end
end
