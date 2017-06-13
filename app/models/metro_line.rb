class MetroLine < ApplicationRecord
	has_many :metro_stations, :inverse_of => :metro_line, dependent: :destroy
	belongs_to :metroable, polymorphic: true
end
