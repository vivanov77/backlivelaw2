class Region < ApplicationRecord
	has_many :cities, :inverse_of => :region, dependent: :destroy
end
