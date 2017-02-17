class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :created_at, :updated_at
  # has_many :comments if false
  has_many :comments

  # def include_comments?
  #   false
  # end
end
