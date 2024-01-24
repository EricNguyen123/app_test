# frozen_string_literal: true

# chat
class ChatRoom < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :remembers, dependent: :destroy
  validates :title, presence: true

  def remembers?(chat_room, user)
    chat_room.remembers.where(user:).exists?
    Remember.where(user_id: user.id, chat_room_id: chat_room.id).exists?
  end
end
