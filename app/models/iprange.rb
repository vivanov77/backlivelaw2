class Iprange < ApplicationRecord
  belongs_to :city

	def self.find_by_ip ip

		a = ip.to_s.split(".").map(&:to_i)

		start = a[0]*256*256*256+a[1]*256*256+a[2]*256+a[3]

		self.where("ip_block_start <= ? AND ip_block_end >= ? ", start, start).first

	end

end
