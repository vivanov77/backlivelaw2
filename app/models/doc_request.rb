class DocRequest < ApplicationRecord
	belongs_to :user, :inverse_of => :doc_requests
	has_many :doc_responses, :inverse_of => :doc_request, dependent: :destroy
	has_and_belongs_to_many :categories

	after_commit :set_response_delta_flags

	private

	def set_response_delta_flags
		doc_responses.each { |response|
		  response.update_attributes :delta => true
		}
	end

	def self.runame
		"Запрос документа"
	end


  # validates :user, presence: true
  # validates :category, presence: true

# after_save :set_response_delta_flags
# after_destroy :set_delta_flag 

# def set_delta_flag

#   doc_responses.first.delta = true
#   doc_responses.first.save

# end

end
