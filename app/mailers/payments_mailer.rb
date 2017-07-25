class PaymentsMailer < ApplicationMailer

  def payment_income(payment, email)

  	@payment = payment

	mail(to: email, subject: 'Создан платёж')

  end

end
