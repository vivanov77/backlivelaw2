class Payment < ApplicationRecord
	belongs_to :sender, class_name: 'User', :inverse_of => :payments
	belongs_to :recipient, class_name: 'User', :inverse_of => :payments

	has_one :payment_type

	before_commit :check_operation, on: [:create, :update, :destroy]

	# accepts_nested_attributes_for :payment_type, allow_destroy: true	
  
	PAYMENT_OPTIONS = {nop: "Нет", canceled: "Возврат платежа"}.freeze

	def option_name

		PAYMENT_OPTIONS.select {|x| x == self.option.to_sym}.values.first

	end

	def purpose

		payment_type = self.try(:payment_type).try(:payable)

		payment_name payment_type

	end

	def typed_purpose
		self.try(:payment_type).try(:payable).try(:class).try(:runame).try(:+,": ").try(:+, self.purpose)
	end

	private

	def validate_operation
		unless self.sender
			raise UserError, "Не указан отправитель платежа."
		end

		unless self.recipient
			raise UserError, "Не указан получатель платежа."
		end		

		unless self.sum
			raise UserError, "Не указана сумма."
		end

	end

	def check_operation

		validate_operation

		if self.sender.get_balance < 0

			# p "self.user.id", self.user.id

			# p "self.user.get_balance", self.user.get_balance

			# p "self.user.total_cash_in", self.user.total_cash_in

			# p "self.user.total_cash_out", self.user.total_cash_out

			# p "self.user.total_payment_in", self.user.total_payment_in

			# p "self.user.total_payment_out", self.user.total_payment_out	

			# p "self.sum", self.sum

			raise UserError, "Недостаточно средств отправителя платежа (его баланс: #{self.sender.get_balance + self.sum}, сумма платежа: #{self.sum})."

		end
	end	
end
