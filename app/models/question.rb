class Question < ApplicationRecord
	belongs_to :user, :inverse_of => :questions
	has_many :responses, :inverse_of => :question
	has_and_belongs_to_many :categories
	paginates_per 20
end
