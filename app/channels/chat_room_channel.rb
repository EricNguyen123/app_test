class ChatRoomChannel < ApplicationCable::Channel
  def subscribed
    chat_room = params[:chat_room_id]
    if chat_room
      stream_from "chat_room_channel_#{ chat_room }"
    else
      reject
    end
  end

  def unsubscribed
    stop_all_streams
  end
end
