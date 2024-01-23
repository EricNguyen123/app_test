# frozen_string_literal: true

# message
class MessagesController < ApplicationController
  before_action :logged_in_user, only: %i[create update destroy]
  before_action :find_message, only: %i[update destroy]

  def create
    @message = current_user.messages.create(message: msg_params[:message], chat_room_id: params[:chat_room_id])
  end

  def update
    return unless @message.update(message: params[:message])

    render json: { success: true }
  end

  def destroy
    @message.destroy
    respond_to(&:turbo_stream)
  rescue ActiveRecord::RecordNotDestroyed
    flash[:error] = 'Message could not be deleted'
    redirect_to request.referrer || root_url
  end

  private

  def find_message
    @message = Message.find(params[:id])
  end

  def msg_params
    params.require(:message).permit(:message)
  end
end
