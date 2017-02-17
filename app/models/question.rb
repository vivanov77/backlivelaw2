class Question < ApplicationRecord
	belongs_to :user, :inverse_of => :questions
	has_and_belongs_to_many :categories
	paginates_per 20
# https://www.codementor.io/ruby-on-rails/tutorial/threaded-comments-polymorphic-associations	
	has_many :comments, as: :commentable, dependent: :destroy
	# accepts_nested_attributes_for :comments
end
