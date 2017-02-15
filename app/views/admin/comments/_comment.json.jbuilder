json.extract! comment, :id, :title, :user_id, :response_id, :created_at, :updated_at
json.url comment_url(comment, format: :json)