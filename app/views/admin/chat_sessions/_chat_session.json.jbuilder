json.extract! chat_session, :id, :specialist_id, :clientable_id, :clientable_type, :closed, :created_at, :updated_at
json.url chat_session_url(chat_session, format: :json)