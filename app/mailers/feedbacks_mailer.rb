class FeedbacksMailer < ApplicationMailer

  def feedback_notification(feedback, email)

  	@feedback = feedback

	mail(to: email, subject: 'Поступил отзыв')

  end

end
