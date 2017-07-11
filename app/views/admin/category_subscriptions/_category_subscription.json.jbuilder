json.extract! category_subscription, :id, :timesubscription, :category_id, :price, :created_at, :updated_at
json.url category_subscription_url(category_subscription, format: :json)