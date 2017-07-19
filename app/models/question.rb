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

	def virtual_attribute_payment

		return nil unless charged

		proposal_ids = Proposal.where(proposable_type: "Question", proposable_id: self.id).map &:id

		Payment.includes(:payment_type).where(payment_types: {payable_type: "Proposal", payable_id:proposal_ids}).

		first

	end

	def parent_question?
		false
	end

	def parent_comment?
		false
	end

	private	

	def self.runame
		"Вопрос"
	end	

	scope :paid, -> do

		includes(proposals: [payment_type: [:payment]]).

		where(proposals: {proposable_type: "Question"}).

		# where("payments.sum > 0")

		where("payments.id is not null")

	end


	scope :unpaid, -> do

		where.not(id: (paid.map &:id))

	end	

	# validates :user, presence: true
	# validates :category, presence: true		

end
