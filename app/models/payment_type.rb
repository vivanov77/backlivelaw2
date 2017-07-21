class PaymentType < ApplicationRecord
# https://gist.github.com/runemadsen/1242485
	belongs_to :payment
	belongs_to :payable, :polymorphic => true

# https://stackoverflow.com/questions/680141/activerecord-querying-polymorphic-associations/45216150#45216150
	PROPOSAL = "INNER JOIN proposals ON payment_types.payable_id = proposals.id AND payment_types.payable_type = 'Proposal'"
	# Payment.joins(:payment_type).joins(PaymentType::PROPOSAL).where(proposals: {id: 1}).all
end
