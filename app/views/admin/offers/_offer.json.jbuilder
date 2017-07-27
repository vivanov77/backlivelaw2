json.extract! offer, :id, :price, :sender_id, :recipient_id, :title, :text, :created_at, :updated_at
json.url offer_url(offer, format: :json)