class ProposalsMailer < ApplicationMailer

  def proposal_created(proposal, email)

  	@proposal = proposal

	mail(to: email, subject: 'Создано ценовое предложение')

  end

end
