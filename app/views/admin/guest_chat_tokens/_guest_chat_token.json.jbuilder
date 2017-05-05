json.extract! guest_chat_token, :id, :guest_login, :guest_password, :created_at, :updated_at
json.url guest_chat_token_url(guest_chat_token, format: :json)