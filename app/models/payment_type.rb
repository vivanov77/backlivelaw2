class PaymentType < ApplicationRecord
# https://gist.github.com/runemadsen/1242485
	belongs_to :payment
	belongs_to :payable, :polymorphic => true	

end
