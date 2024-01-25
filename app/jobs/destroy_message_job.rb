# frozen_string_literal: true

# job
class DestroyMessageJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast("chat_room_channel_#{message.chat_room_id}", { action: 'destroy', msg_id: message.id })
  end
end
