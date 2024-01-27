# frozen_string_literal: true

# messages
class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room
end
