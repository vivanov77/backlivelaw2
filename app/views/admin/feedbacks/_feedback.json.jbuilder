json.extract! feedback, :id, :title, :text, :paid, :user_id, :created_at, :updated_at
json.url feedback_url(feedback, format: :json)