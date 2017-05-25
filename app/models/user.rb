class User < ApplicationRecord

  include ApplicationHelper
  
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          # :confirmable,
          :omniauthable
  include DeviseTokenAuth::Concerns::User
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

  # has_one :file_container, as: :fileable, dependent: :destroy
  # accepts_nested_attributes_for :file_container, allow_destroy: true

  mount_uploader :avatar, AvatarUploader

# see config/application.rb
# config.roles = {client:"Клиент", admin:"Администратор", jurist:"Юрист", lawyer:"Адвокат", blocked: "Заблокирован"}

# http://guides.rubyonrails.org/active_record_querying.html#scopes
# http://stackoverflow.com/questions/26159533/rails-includes-with-scope

  scope :roled, -> (role){ includes(:roles).where(roles: { name: role}) }

  validates :experience, numericality: { only_integer: true }, allow_nil: true
  validates :price, numericality: true, allow_nil: true
  validates :balance, numericality: true, allow_nil: true

# http://guides.rubyonrails.org/active_record_validations.html#performing-custom-validations
  include ActiveModel::Validations
  validates_with SingleCityValidator

  def self.formatted_users city, user_id = nil, local_regions = false, other_regions = false

    if city

      lat = city.latitude

      lon = city.longitude

      region_id = city.region_id

    end

    region_users = User.where.not(id: user_id).includes(:cities).includes(:roles)

    unless (local_regions && other_regions)

      if local_regions

        region_users = region_users.where(cities: {region_id: region_id})

      elsif other_regions

        region_users = region_users.where.not(cities: {region_id: region_id})

      # elsif local_regions && other_regions

      end

    end    

    region_users = region_users.map do |u| 

      h = {}

      h[:user]=u

      h[:role]=u.roles.first

      h[:city] = u.cities.first

      if city

        diff_lat = u.cities.first.latitude - lat

        diff_lon = u.cities.first.longitude - lon

        sq_dist = diff_lat*diff_lat + diff_lon * diff_lon

        h[:distance] = Math.sqrt sq_dist

      else

        h[:distance] = nil

      end

      h

    end

    if city

      region_users.sort_by { |hsh| hsh[:distance] }

    else

      region_users.sort_by { |hsh| hsh[:user][:email] }      

    end

  end

end