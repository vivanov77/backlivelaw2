class Category < ApplicationRecord
	has_and_belongs_to_many :questions
	has_and_belongs_to_many :doc_requests
end
