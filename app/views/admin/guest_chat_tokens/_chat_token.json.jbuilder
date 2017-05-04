json.extract! chat_token, :id, :guest_login, :guest_password, :created_at, :updated_at
json.url chat_token_url(chat_token, format: :json)