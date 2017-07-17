# Be sure to restart your server when you modify this file.

# https://stackoverflow.com/questions/516579/is-there-a-way-to-get-a-collection-of-all-the-models-in-your-rails-app

Rails.application.eager_load!

Rails.application.config.payment_types = 

ApplicationRecord.descendants.select do |model|

	model.instance_methods.include?(:payment_type) &&

	model.instance_methods.include?(:payment)

end

Rails.application.config.proposal_types = 

ApplicationRecord.descendants.select do |model|

	model.instance_methods.include?(:proposals)

end