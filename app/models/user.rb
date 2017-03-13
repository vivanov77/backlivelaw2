class User < ApplicationRecord

  include ApplicationHelper
  
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          # :confirmable,
          :omniauthable
  include DeviseTokenAuth::Concerns::User
  rolify
  has_many :questions, :inverse_of => :user
  has_many :comments, :inverse_of => :user
  has_and_belongs_to_many :cities

  # resourcify

# see config/application.rb
# config.roles = {client:"Клиент", admin:"Администратор", lawyer:"Юрист", advocate:"Адвокат", blocked: "Заблокирован"}

# http://guides.rubyonrails.org/active_record_querying.html#scopes
# http://stackoverflow.com/questions/26159533/rails-includes-with-scope

  scope :roled, -> (role){ includes(:roles).where(roles: { name: role}) }

  validates :experience, numericality: { only_integer: true }, allow_nil: true
  validates :price, numericality: true, allow_nil: true
  validates :balance, numericality: true, allow_nil: true

# http://guides.rubyonrails.org/active_record_validations.html#performing-custom-validations
  include ActiveModel::Validations
  validates_with SingleCityValidator

end