class DocRequest < ApplicationRecord
  belongs_to :user, :inverse_of => :doc_requests
  has_many :doc_responses, :inverse_of => :doc_request, dependent: :destroy
  has_and_belongs_to_many :categories

  # validates :user, presence: true
  # validates :category, presence: true
end
