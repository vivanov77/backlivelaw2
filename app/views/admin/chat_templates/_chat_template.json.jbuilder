json.extract! chat_template, :id, :text, :user_id, :created_at, :updated_at
json.url chat_template_url(chat_template, format: :json)