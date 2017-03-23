class Comment < ApplicationRecord
	belongs_to :user, :inverse_of => :comments
# https://www.codementor.io/ruby-on-rails/tutorial/threaded-comments-polymorphic-associations	
	belongs_to :commentable, polymorphic: true
	has_many :comments, as: :commentable, dependent: :destroy

	before_save :check_for_too_nested
	before_save :check_for_orphaned	

	def parent_question?
		commentable_type.to_s.downcase == "question"
	end

	def parent_comment?
		commentable_type.to_s.downcase == "comment"
	end

# Does not let you save the comment if his parent is a comment's comment
# http://stackoverflow.com/questions/23837573/rails-4-how-to-cancel-save-on-a-before-save-callback
	def check_for_too_nested
		if commentable && commentable.parent_comment?
			errors.add(:base, "Нельзя создать комментарий с уровнем вложенности больше 1 (считая с 0).")
			throw :abort
		end
	end

	def check_for_orphaned
		unless commentable
			errors.add(:errors, "Нельзя создать комментарий, не подчинённый ни одному вопросу.")
			throw :abort
		end
	end
end
