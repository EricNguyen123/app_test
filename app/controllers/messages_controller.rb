# frozen_string_literal: true

# message
class MessagesController < ApplicationController
  before_action :logged_in_user, only: %i[create update destroy]
  before_action :find_message, only: %i[update destroy]

  def create
    @message = current_user.messages.create(message: msg_params[:message], chat_room_id: params[:chat_room_id])
    CreateMessageJob.perform_later(@message) if @message.save
  rescue ActiveRecord::RecordInvalid
    flash[:error] = 'Message could not be created'
    redirect_to request.referrer || root_url
  end

  def update
    return redirect_to request.referrer || root_url unless @message.update(message: params[:message])

    UpdateMessageJob.perform_later(@message)
  end

  def destroy
    DestroyMessageJob.perform_now(@message) if @message&.destroy
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
