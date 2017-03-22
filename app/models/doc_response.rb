class DocResponse < ApplicationRecord
  belongs_to :user, :inverse_of => :doc_responses
  belongs_to :doc_request, :inverse_of => :doc_responses
  has_many :file_containers, as: :fileable, dependent: :destroy
  accepts_nested_attributes_for :file_containers, allow_destroy: true  

  # validates :user, presence: true
  # validates :doc_request, presence: true
end
