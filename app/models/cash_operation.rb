class CashOperation < ApplicationRecord
	belongs_to :user, :inverse_of => :cash_operations

	# before_commit :transfer, on: [:create]
	before_commit :check_operation, on: [:create, :update, :destroy]

	# before_commit :check_destroy, on: [:destroy, :update]	

	# before_commit :undo_transfer, on: [:destroy]	

	CASH_OPERATION_TYPES = {nop: "Нет действия", in: "Пополнение баланса", out: "Вывод средств"}.freeze

	def operation_name

		CASH_OPERATION_TYPES.select {|x| x == self.operation.to_sym}.values.first

	end

	private

	def validate_operation
		unless self.user
			raise UserError, "Не указан пользователь, совершающий операцию."
		end

		unless self.sum
			raise UserError, "Не указана сумма."
		end

		unless self.operation
			raise UserError, "Не указана операция."
		end
	end

	def check_operation

		validate_operation

		if 

			# (self.operation == "out") && (

			self.user.get_balance < 0

			# )

			# p "self.user.id", self.user.id

			# p "self.user.get_balance", self.user.get_balance

			# p "self.user.total_cash_in", self.user.total_cash_in

			# p "self.user.total_cash_out", self.user.total_cash_out

			# p "self.user.total_payment_in", self.user.total_payment_in

			# p "self.user.total_payment_out", self.user.total_payment_out	

			# p "self.sum", self.sum

			raise UserError, "Недостаточно средств (баланс пользователя \"#{self.user.email}\": #{self.user.get_balance + self.sum}, сумма операции: #{self.sum})."

		end

	end

end
