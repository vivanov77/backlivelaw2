class Region < ApplicationRecord
	has_many :cities, :inverse_of => :region
end
