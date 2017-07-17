class Question < ApplicationRecord
	belongs_to :user, :inverse_of => :questions
	has_and_belongs_to_many :categories
	paginates_per 20
# https://www.codementor.io/ruby-on-rails/tutorial/threaded-comments-polymorphic-associations	
	has_many :comments, as: :commentable, dependent: :destroy

	has_many :file_containers, as: :fileable, dependent: :destroy
	accepts_nested_attributes_for :file_containers, allow_destroy: true

	# has_one :payment_type, :as =>:payable
	# has_one :payment, :through => :payment_type

	has_many :proposals, :as =>:proposable

	# has_one :file_container, as: :fileable, dependent: :destroy
	# accepts_nested_attributes_for :file_container

	def parent_question?
		false
	end

	def parent_comment?
		false
	end

	def self.runame
		"Вопрос"
	end

	# validates :user, presence: true
	# validates :category, presence: true		

end
