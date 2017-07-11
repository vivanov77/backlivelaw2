json.extract! payment, :id, :text, :created_at, :updated_at
json.url citation_url(payment, format: :json)