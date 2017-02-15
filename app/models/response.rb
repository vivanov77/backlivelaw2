class Response < ApplicationRecord
	belongs_to :user, :inverse_of => :responses
	belongs_to :question, :inverse_of => :responses
end
