class Comment < ApplicationRecord
	belongs_to :user, :inverse_of => :comments
# https://www.codementor.io/ruby-on-rails/tutorial/threaded-comments-polymorphic-associations	
	belongs_to :commentable, polymorphic: true
	has_many :comments, as: :commentable, dependent: :destroy
	# accepts_nested_attributes_for :comments

	scope :questions, -> { where(commentable_type: "Question") }
	scope :comments, -> { where(commentable_type: "Comment") }	

end
