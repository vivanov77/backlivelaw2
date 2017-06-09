class City < ApplicationRecord
	belongs_to :region, :inverse_of => :cities
	has_many :ipranges, :inverse_of => :city, dependent: :destroy
	has_and_belongs_to_many :users
	has_many :metro_lines, as: :metroable, dependent: :destroy
end
