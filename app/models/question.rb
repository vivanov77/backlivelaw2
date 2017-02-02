class Question < ApplicationRecord
  has_and_belongs_to_many :users
  paginates_per 5
end
