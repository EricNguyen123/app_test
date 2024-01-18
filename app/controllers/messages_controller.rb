class MessagesController < ApplicationController
  before_action :logged_in_user, only: %i[create]
  def create
    @message = current_user.messages.create(message: msg_params[:message], chat_room_id: params[:chat_room_id])
    
  end

  private

  def msg_params
    params.require(:message).permit(:message)
  end
end
