class CommentsMailer < ApplicationMailer

  def comment_created(comment, email)

  	@comment = comment

	mail(to: email, subject: 'Получен комментарий (ответ)')

  end

end
