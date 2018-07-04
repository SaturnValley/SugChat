json.extract! chat, :id, :chat_room_id, :message, :user_id, :created_at, :updated_at
json.url chat_url(chat, format: :json)
