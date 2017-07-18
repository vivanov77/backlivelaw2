class DocResponse < ApplicationRecord
  belongs_to :user, :inverse_of => :docs
  belongs_to :doc_request, :inverse_of => :docs
  has_many :file_containers, as: :fileable, dependent: :destroy
  accepts_nested_attributes_for :file_containers, allow_destroy: true

  # has_one :payment_type, :as =>:payable
  # has_one :payment, :through => :payment_type

  def self.runame
	"Выполненный заказ на документ"
  end

end
