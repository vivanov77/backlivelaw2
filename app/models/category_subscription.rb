class CategorySubscription < ApplicationRecord
	belongs_to :category, :inverse_of => :category_subscriptions

	has_one :payment_type, :as =>:payable
	has_one :payment, :through => :payment_type

	TIME_SPANS = {day_1: "1 день", day_3: "3 дня", day_7: "7 дней", 
		month_1: "1 месяц", month_3: "3 месяца", month_6: "6 месяцев", month_12: "12 месяцев"}.freeze

	def self.runame
		"Подписка на категорию"
	end

	def timespan_name
		TIME_SPANS[timespan.to_sym]
	end

	def expiration start_date

		return nil unless self.timespan

		ts = self.timespan.split "_"

		start_date + (ts.second.to_i.send ts.first.to_sym)

	end
end
