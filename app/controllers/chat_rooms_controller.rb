class ChatRoomsController < ApplicationController
  before_action :logged_in_user, only: %i[index create show]
  
  def index
    @chat_room = ChatRoom.new
    @chat_rooms = ChatRoom.all
    @user_chats = User.all_except(current_user)
  end

  def create
    @chat_room = ChatRoom.create(title: params['chat_room']['title'])
    Remember.create(user_id: current_user.id, chat_room_id: @chat_room.id)
  end

  def show
    @single_room = ChatRoom.find(params[:id])
    current_user.remembers.find_by(chat_room_id: @single_room.id)

    @chat_rooms = ChatRoom.all
    @user_chats = User.all_except(current_user)
    @chat_room = ChatRoom.new
    @message = Message.new

    @messages = @single_room.messages.order(created_at: :asc)
    render 'index'
  end
end
