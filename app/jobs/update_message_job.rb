# frozen_string_literal: true

# job
class UpdateMessageJob < ApplicationJob
  queue_as :default

  def perform(message)
    html = ApplicationController.render(
      partial: 'messages/update_msg',
      locals: { message: }
    )
    ActionCable.server.broadcast("chat_room_channel_#{message.chat_room_id}", { html:, action: 'update', msg_id: message.id })
  end
end
