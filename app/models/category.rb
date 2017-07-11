class Category < ApplicationRecord
	has_and_belongs_to_many :questions
	has_and_belongs_to_many :doc_requests

	# has_one :payment_type, :as =>:payable
	# has_one :payment, :through => :payment_type

	has_many :category_subscriptions, :inverse_of => :category, dependent: :destroy	

	def self.runame
		"Категория"
	end

	after_commit :create_category_subscriptions, on: [:create]

	def create_category_subscriptions

		CategorySubscription::TIME_SPANS.each do |key, value|

			self.category_subscriptions << (CategorySubscription.create! timespan: key, price: 0)

		end

	end
end
