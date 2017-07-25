class QuestionsMailer < ApplicationMailer

  def question_created(question, email, password)

  	@question = question

  	@password = password

  	@email = email

	mail(to: email, subject: 'Создан вопрос')

  end

end
