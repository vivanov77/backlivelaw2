class QuestionsMailer < ApplicationMailer

  def question_created(question, email, password, confirmation_token)

  	@question = question

  	@password = password

  	@email = email

  	@token = confirmation_token

	mail(to: email, subject: 'Создан вопрос')

  end

end
