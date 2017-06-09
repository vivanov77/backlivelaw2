class Region < ApplicationRecord
	has_many :cities, :inverse_of => :region, dependent: :destroy
	has_many :metro_lines, as: :metroable, dependent: :destroy
end
