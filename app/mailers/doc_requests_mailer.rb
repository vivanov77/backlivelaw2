class DocRequestsMailer < ApplicationMailer

  def doc_request_created(doc_request, email, password)

  	@doc_request = doc_request

  	@password = password

  	@email = email  	

	mail(to: email, subject: 'Создан заказ на документ')

  end

end
