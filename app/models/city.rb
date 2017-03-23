class City < ApplicationRecord
	belongs_to :region, :inverse_of => :cities
	has_many :ipranges, :inverse_of => :city
	has_and_belongs_to_many :users
end
