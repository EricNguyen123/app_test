# frozen_string_literal: true

# chat
class ChatRoom < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :remember_rooms, dependent: :destroy
  validates :title, presence: true

  def remember_rooms?(chat_room, user)
    chat_room.remember_rooms.where(user:).exists?
    RememberRoom.where(user_id: user.id, chat_room_id: chat_room.id).exists?
  end
end
