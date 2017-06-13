class MetroStation < ApplicationRecord
	belongs_to :metro_line, :inverse_of => :metro_stations
end
