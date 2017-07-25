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

	def user_purpose

		payment_type = self.try(:payment_type).try(:payable)

		user_payment_name payment_type

	end	

	# def typed_purpose
	# 	self.try(:payment_type).try(:payable).try(:class).try(:runame).try(:+,": ").try(:+, self.purpose)
	# end

	def typed_purpose

		class_name = self.try(:payment_type).try(:payable).try(:class).try(:runame)

		if purpose && class_name

		  class_name + ": " + purpose

		else

		  nil

		end

	end

	# def partner_id user_id

	# 	if user_id == sender_id
	# 		recipient_id
	# 	elsif user_id == recipient_id
	# 		sender_id
	# 	else
	# 		nil
	# 	end
	# end

	def unfreeze_payment?

# self.payment_type.payable => Proposal

# self.payment_type.payable.proposable => DocRequest

# Payment 1-->1 PaymentType 1-->1 Proposal n-->1 DocRequest - каждому Payment соответствует только один DocRequest и один Proposal. 

# Payment оплачивается либо за один Proposal, либо за один CategorySubscription. Proposal всегда создаются (lawyer, advocate).

# Надо узнать автора Proposal, затем у DocRequest'а Payment'а найти подчинённый DocResponse с таким же автором.

# Это возможно, потому что каждый специалист может сделать только одно ценовое предложение на любую заказываемую клиентом сущность.

# И дальше проверять состояние DocResponse, чтобы на этом основании принять решение о разморозке Payment.            

		proposal = self.try(:payment_type).try(:payable)

		raise UserError, "У платежа с id: #{self.id} нет ценового предложения" unless proposal

		doc_request = proposal.try(:proposable)

		raise UserError, "У платежа с id: #{self.id} нет заказа на документ" unless doc_request

		doc_response = DocResponse.where(doc_request_id: doc_request.id, user_id: proposal.user_id).first

		raise UserError, "У платежа с id: #{self.id} нет выполненного заказа на документ" unless doc_response

		check_time_limit = Time.now - doc_response.created_at

		if doc_response.check_date # Пользователь открывал выполненное задание на документ хотя бы раз

	# Если пользователь открыл выполненное задание на документ позднее чем 3 дня с момента его создания
		    return true if ((doc_response.check_date - doc_response.created_at) > 3.days)

		    if doc_response.complaint_date # Пользователь пожаловался на выполненное задание на документ

# Теоретически невозможный случай: должен не допускаться в принципе на более ранних этапах -
# а именно, если уже прошло 3 дня с момента создания, блокировка не даёт заполнить doc_response.complaint_date.
# но на всякий случай обработаем эту ситуацию тоже:

# Если пользователь пожаловался позднее, чем через 4 дня с момента создания выполненного задания на документ
				return true if ((doc_response.complaint_date - doc_response.created_at) > 4.days)

# Теоретически невозможный случай: .....				
# Если пользователь пожаловался позднее, чем через 1 сутки после момента ознакомления
				return true if ((doc_response.complaint_date - doc_response.check_date) > 1.day)

		    else
# Если прошло более 1 суток с момента ознакомления и жалоб не было
				return true if ((Time.now - doc_response.check_date) > 1.day)    	

		    end	    

		else

	# Если пользователь даже не открывал выполненное задание на документ в течение 3 дней с момента его создания
		    return true unless (check_time_limit > 3.days)

		end

		false

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

		# if self.sender.get_balance < 0
		if self.sender.get_accessible_balance < 0

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

	def self.frozen_doc_response_payments user_id

		Payment.where(cfrozen: true).

		where("sender_id = ? OR recipient_id = ?", user_id, user_id).

		joins(:payment_type).joins(PaymentType::PROPOSAL).

		all		

	end
end
