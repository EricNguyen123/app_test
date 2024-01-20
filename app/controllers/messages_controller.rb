class MessagesController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  before_action :find_message, only: %i[destroy]
  
  def create
    @message = current_user.messages.create(message: msg_params[:message], chat_room_id: params[:chat_room_id])
  end

  def destroy
    begin
      @message.destroy
      respond_to do |format|
        format.turbo_stream
      end
    rescue ActiveRecord::RecordNotDestroyed
      flash[:error] = 'Message could not be deleted'
      redirect_to request.referrer || root_url
    end
  end

  private

  def find_message
    @message = Message.find(params[:id])
  end

  def msg_params
    params.require(:message).permit(:message)
  end
end
