class ChatRoomsController < ApplicationController
  before_action :logged_in_user

  def index
    @chat_room = ChatRoom.new
    @chat_rooms = ChatRoom.all
    @users = User.all_except(current_user)
  end

  def create
    @chat_room = ChatRoom.create(title: params['chat_room']['title'])
  end

  def show
    @single_room = ChatRoom.find(params[:id])
    current_user.update_without_password(room_id: @single_room.id)

    @chat_rooms = ChatRoom.all
    @users = User.all_except(current_user)
    @chat_room = ChatRoom.new
    @message = Message.new

    @messages = @single_room.messages.order(created_at: :asc)
    render 'index'
  end
end
