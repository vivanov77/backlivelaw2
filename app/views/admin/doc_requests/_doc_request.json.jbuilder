json.extract! doc_request, :id, :title, :text, :paid, :user_id, :created_at, :updated_at
json.url doc_request_url(doc_request, format: :json)