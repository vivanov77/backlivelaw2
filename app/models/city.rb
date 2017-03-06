class City < ApplicationRecord
	belongs_to :region
	has_many :ipranges, :inverse_of => :city  
end
