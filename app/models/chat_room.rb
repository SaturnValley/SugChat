class ChatRoom < ApplicationRecord
  has_many :participants
  has_many :strokes
end
