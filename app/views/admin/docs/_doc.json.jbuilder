json.extract! doc, :id, :chosen, :text, :price, :user_id, :doc_request_id, :created_at, :updated_at
json.url doc_url(doc, format: :json)