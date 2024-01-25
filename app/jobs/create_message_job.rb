# frozen_string_literal: true

# job
class CreateMessageJob < ApplicationJob
  queue_as :default

  def perform(message)
    html = ApplicationController.render(
      partial: 'messages/message',
      locals: { message: }
    )
    ActionCable.server.broadcast("chat_room_channel_#{message.chat_room_id}", { html:, action: 'create' })
  end
end
