class User < ApplicationRecord

  include ApplicationHelper

  # before_commit :check_operation, on: [:create, :update]  
  
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable,
          :omniauthable,
# http://stackoverflow.com/questions/8186584/how-do-i-set-up-email-confirmation-with-devise
         :omniauth_providers => [:facebook, :vkontakte]

  include DeviseTokenAuth::Concerns::User

  devise :omniauthable

  rolify
  has_many :questions, :inverse_of => :user, dependent: :destroy
  has_many :comments, :inverse_of => :user, dependent: :destroy
  has_and_belongs_to_many :cities
  has_many :doc_requests, :inverse_of => :user, dependent: :destroy
  has_many :doc_responses, :inverse_of => :user, dependent: :destroy
  # has_many :messages, foreign_key: 'sender_id', :inverse_of => :user
  has_many :messages, foreign_key: 'sender_id', dependent: :destroy
  # has_one :chat_token, :inverse_of => :user
  has_many :chat_messages, as: :sendable, dependent: :destroy

  has_many :feedbacks, :inverse_of => :user, dependent: :destroy  

  # has_one :file_container, as: :fileable, dependent: :destroy
  # accepts_nested_attributes_for :file_container, allow_destroy: true

  mount_uploader :avatar, AvatarUploader

  has_many :cash_operations, :inverse_of => :user, dependent: :destroy

  has_many :payments, foreign_key: 'sender_id', dependent: :destroy

  has_many :offers, foreign_key: 'sender_id', dependent: :destroy  

# see config/application.rb
# config.roles = {client:"Клиент", admin:"Администратор", jurist:"Юрист", lawyer:"Адвокат", blocked: "Заблокирован"}

# http://guides.rubyonrails.org/active_record_querying.html#scopes
# http://stackoverflow.com/questions/26159533/rails-includes-with-scope

  scope :roled, -> (role){ includes(:roles).where(roles: { name: role}) }

  validates :experience, numericality: { only_integer: true }, allow_nil: true
  validates :price, numericality: true, allow_nil: true
  validates :balance, numericality: true, allow_nil: true

  # validates :login, uniqueness: true  

# http://guides.rubyonrails.org/active_record_validations.html#performing-custom-validations
  include ActiveModel::Validations
  validates_with SingleCityValidator

  # def self.formatted_users city, user_id = nil, local_regions = false, other_regions = false

  #   if city

  #     lat = city.latitude

  #     lon = city.longitude

  #     region_id = city.region_id

  #   end

  #   region_users = User.where.not(id: user_id).includes(:cities).includes(:roles)

  #   # unless (local_regions && other_regions)

  #   #   if local_regions

  #   #     region_users = region_users.where(cities: {region_id: region_id})

  #   #   elsif other_regions

  #   #     region_users = region_users.where.not(cities: {region_id: region_id})

  #   #   # elsif local_regions && other_regions

  #   #   end

  #   # end    

  #   region_users = region_users.map do |u| 

  #     h = {}

  #     h[:user]=u

  #     h[:role]=u.roles.first

  #     h[:city] = u.cities.size == 0 ? :user_has_no_city : u.cities.first

  #     if city && (u.cities.size > 0)

  #       diff_lat = u.cities.first.latitude - lat

  #       diff_lon = u.cities.first.longitude - lon

  #       sq_dist = diff_lat*diff_lat + diff_lon * diff_lon

  #       h[:distance] = Math.sqrt sq_dist

  #     else

  #       h[:distance] = nil

  #     end

  #     h

  #   end

  #   if city

  #     region_users.sort_by { |hsh| hsh[:distance] }

  #   else

  #     region_users.sort_by { |hsh| hsh[:user][:email] }      

  #   end

  # end

  def self.from_omniauth(auth)

    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      # user.name = auth.info.name   # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
      user.confirm
    end
  end

  def self.from_omniauth_vkontakte(auth)
# p "auth", auth
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      # user.email = auth.info.email
# https://habrahabr.ru/post/142128/     

# logger.debug auth

      # user.email = auth.extra.raw_info.id.to_s + '@vk.com'
      user.email = auth.extra.raw_info.first_name.to_s + "." + auth.extra.raw_info.last_name.to_s + '@vk.com'      
      user.password = Devise.friendly_token[0,20]
      # user.name = auth.info.name   # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
      user.confirm
    end
  end 

  def uploader_name

    uploader_name_helper self

  end

  def total_cash_in
    CashOperation.where(user_id: self.id).where(operation: "in").sum("sum")
  end

  def total_cash_out
    CashOperation.where(user_id: self.id).where(operation: "out").sum("sum")
  end

  def total_payment_in
    Payment.where(recipient_id: self.id).sum("sum")
  end

  def total_payment_out
    Payment.where(sender_id: self.id).sum("sum")
  end

  def total_notfrozen_payment_in
    Payment.where(recipient_id: self.id, cfrozen: false).sum("sum")
  end

  def total_notfrozen_payment_out
    Payment.where(sender_id: self.id, cfrozen: false).sum("sum")
  end  

  def total_frozen_payment_in
    Payment.where(recipient_id: self.id, cfrozen: true).sum("sum")
  end

  def total_frozen_payment_out
    Payment.where(sender_id: self.id, cfrozen: true).sum("sum")
  end

  def income
    total_cash_in + total_payment_in
  end

  def outcome
    total_cash_out + total_payment_out
  end

  def _nominal_balance

    total_cash_in - total_cash_out + total_notfrozen_payment_in - total_notfrozen_payment_out

  end

  def get_nominal_balance

    if get_frozen_balance < 0

      _nominal_balance

    else

      _nominal_balance + get_frozen_balance

    end

  end

  def get_frozen_balance

    total_frozen_payment_in - total_frozen_payment_out

  end

  def get_accessible_balance

    if get_frozen_balance < 0

      _nominal_balance + get_frozen_balance

    else

      _nominal_balance

    end

  end

  def purchased_category_subscriptions
    # http://guides.rubyonrails.org/active_record_querying.html#nested-associations-hash
    category_subscriptions = CategorySubscription.

    includes(payment_type: [:payment]).

    where(payment_types: {payable_type: "CategorySubscription"}).

    where(payments: {sender_id: self.id}).

    order(:category_id)
    
  end

  def actual_purchased_category_subscriptions
    purchased_category_subscriptions.select {|x| (x.expiration x.payment.created_at) >= Time.now}
  end

  def actual_purchased_categories
    # purchased_category_subscriptions.select{|x| (x.expiration x.payment.created_at) >= Time.now}.

    Category.includes(:category_subscriptions).where(category_subscriptions: {category_id: (actual_purchased_category_subscriptions.map &:category_id)})
    
  end  

  # def check_operation

  #   admin_count = User.includes(:roles).where(roles: {name: "admin"}).count

  #   if admin_count > 1

  #     # self.remove_role :admin
  #     # self.save!

  #     raise DoubleAdminError, "На сайте может быть только один админ. У пользователя #{self.email} роль админа автоматически убрана.)."

  #   end

  # end

  def self.random_password

    Devise.friendly_token[0,20]

  end

end