class Proposal < ApplicationRecord
  belongs_to :user
  belongs_to :proposable, :polymorphic => true

  has_one :payment_type, :as =>:payable
  has_one :payment, :through => :payment_type 

  validates :price, presence: true  

  def self.runame
    "Предложение"
  end

  def name

    self.try(:proposable).try(:title) || self.try(:proposable).try(:doc_request).try(:title)

  end

  def purpose

    class_name = self.try(:proposable).try(:class).try(:runame)

    if name && class_name

      class_name + ": " + name

    else

      nil

    end
	
  end

end