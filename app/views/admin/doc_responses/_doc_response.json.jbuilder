json.extract! doc_response, :id, :chosen, :text, :price, :user_id, :doc_response_request_id, :created_at, :updated_at
json.url doc_response_url(doc_response, format: :json)