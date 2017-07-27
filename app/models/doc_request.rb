class DocRequest < ApplicationRecord
	belongs_to :user, :inverse_of => :doc_requests
	has_many :doc_responses, :inverse_of => :doc_request, dependent: :destroy
	has_and_belongs_to_many :categories

	has_many :file_containers, as: :fileable, dependent: :destroy
	accepts_nested_attributes_for :file_containers, allow_destroy: true	

	has_many :proposals, :as =>:proposable

	after_commit :set_response_delta_flags

	def virtual_relation_payment

		proposal_ids = Proposal.where(proposable_type: "DocRequest", proposable_id: self.id).map &:id

		Payment.includes(:payment_type).where(payment_types: {payable_type: "Proposal", payable_id:proposal_ids}).

		first

	end	

	private

	def set_response_delta_flags
		doc_responses.each { |response|
		  response.update_attributes :delta => true
		}
	end

	def self.runame
		"Заказ документа"
	end

	scope :paid, -> do

		includes(proposals: [payment_type: [:payment]]).

		where(proposals: {proposable_type: "DocRequest"}).

		# where("payments.sum > 0")

		where("payments.id is not null")

	end


	scope :unpaid, -> do

		where.not(id: (paid.map &:id))

	end

	# scope :unpaid_categorized, ->(actual_purchased_categories) do

	# 	unpaid.includes(:categories).where(categories: {id: (actual_purchased_categories.map &:id)})

	# end	

  # validates :user, presence: true
  # validates :category, presence: true

end
