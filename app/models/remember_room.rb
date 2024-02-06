# frozen_string_literal: true

# remember_room
class RememberRoom < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room
  validates :user_id, presence: true
  validates :chat_room_id, presence: true
end