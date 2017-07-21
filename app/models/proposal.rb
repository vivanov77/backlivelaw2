class Proposal < ApplicationRecord
  belongs_to :user
  belongs_to :proposable, :polymorphic => true

  has_one :payment_type, :as =>:payable
  has_one :payment, :through => :payment_type

  validates :price, presence: true

# https://www.codementor.io/ruby-on-rails/tutorial/threaded-comments-polymorphic-associations 
  has_many :comments, as: :commentable, dependent: :destroy  

  def self.runame
    "Предложение"
  end

  def name

    self.try(:proposable).try(:title) || self.try(:proposable).try(:doc_request).try(:title)

  end

  def parent_comment?
    false
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