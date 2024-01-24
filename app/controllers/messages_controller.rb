# frozen_string_literal: true

# message
class MessagesController < ApplicationController
  before_action :logged_in_user, only: %i[create update destroy]
  before_action :find_message, only: %i[update destroy]

  def create
    @message = current_user.messages.create(message: msg_params[:message], chat_room_id: params[:chat_room_id])
    html = render(partial: 'messages/message', locals: { message: @message })
    ActionCable.server.broadcast("chat_room_channel_#{params[:chat_room_id]}", { html:, action: 'create' })
  rescue ActiveRecord::RecordInvalid
    flash[:error] = 'Message could not be created'
    redirect_to request.referrer || root_url
  end

  def update
    redirect_to request.referrer || root_url unless @message.update(message: params[:message])
    html = render(partial: 'messages/update_msg', locals: { message: @message })
    ActionCable.server.broadcast("chat_room_channel_#{params[:chat_room_id]}", { html:, action: 'update', msg_id: @message.id })
  end

  def destroy
    @message.destroy
    ActionCable.server.broadcast("chat_room_channel_#{params[:chat_room_id]}", { action: 'destroy', msg_id: @message.id })
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
