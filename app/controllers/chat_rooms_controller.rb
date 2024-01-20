class ChatRoomsController < ApplicationController
  before_action :logged_in_user, only: %i[index create show destroy]
  before_action :find_chat_room, only: %i[destroy]

  def index
    show_users_and_rooms
  end

  def create
    @chat_room = ChatRoom.create(title: params['chat_room']['title'])
    Remember.create(user_id: current_user.id, chat_room_id: @chat_room.id)
  end

  def show
    @single_room = ChatRoom.find(params[:id])
    show_users_and_rooms
    show_message
    render 'index'
  end

  def destroy
    begin
      @chat_room.destroy!
      flash[:success] = 'Chat Room deleted'
    rescue ActiveRecord::RecordNotDestroyed
      flash[:error] = 'Chat Room could not be deleted'
    end
    redirect_to chat_rooms_path || root_url
  end

  private

  def find_chat_room
    @chat_room = ChatRoom.find(params[:id])
  end

  def show_message
    @message = Message.new
    @messages = @single_room.messages.order(created_at: :asc)
  end

  def show_users_and_rooms
    @chat_rooms = find_all_chat_room
    @chat_room = ChatRoom.new
    @user_chats = find_users
  end

  def find_users
    all_users = current_user.following + current_user.followers
    users = all_users.uniq - [current_user] if all_users.uniq
  end

  def find_all_chat_room
    chat_rooms = ChatRoom.where(id: current_user.remembers) 
  end
end
