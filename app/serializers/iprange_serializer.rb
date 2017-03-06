class IprangeSerializer < ActiveModel::Serializer
  attributes :id, :ip_block_start, :ip_block_end, :ip_range, :kladr_city_code
  has_one :city
end
