class Offer < ApplicationRecord
	
	belongs_to :sender, class_name: 'User', :inverse_of => :offers	
	belongs_to :recipient, class_name: 'User', :inverse_of => :offers

	has_one :payment_type, :as =>:payable
	has_one :payment, :through => :payment_type	

	def self.runame
		"Счёт"
	end

	def virtual_relation_payment

		Payment.includes(:payment_type).where(payment_types: {payable_type: "Offer", payable_id: self.id}).

		first

	end	
	
end
