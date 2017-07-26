class DocRequestsMailer < ApplicationMailer

  def doc_request_created(doc_request, email, password, confirmation_token)

  	@doc_request = doc_request

  	@password = password

  	@email = email
  	
  	@token = confirmation_token  	

	mail(to: email, subject: 'Создан заказ на документ')

  end

end
