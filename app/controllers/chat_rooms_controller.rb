class ChatRoomsController < ApplicationController
  before_action :logged_in_user, only: %i[index create show destroy]
  before_action :find_chat_room, only: %i[destroy add_confirm]

  def index
    show_users_and_rooms
  end

  def create
    @chat_room = ChatRoom.create(title: params['chat_room']['title'])
    @remember = Remember.create(user_id: current_user.id, chat_room_id: @chat_room.id)
  end

  def show
    @single_room = ChatRoom.find(params[:id])
    show_users_and_rooms
    show_message
    render 'index'
  end

  def destroy
    begin
      @chat_room.destroy
      respond_to do |format|
        format.turbo_stream
      end
    rescue ActiveRecord::RecordNotDestroyed
      flash[:error] = 'Chat Room could not be deleted'
      redirect_to chat_rooms_path || root_url
    end
  end

  def create_chat_room_user
    @user = User.find(params[:id])
    show_users_and_rooms
    @chat_room_name = get_name(@user, current_user)
    @single_room = ChatRoom.where(title: @chat_room_name).first || create_chat_user1_user2(@user, @chat_room_name)
    show_message
    render 'index'
  end

  def add_room_for_user
    @remember = Remember.create(user_id: params[:user_id], chat_room_id: params[:chat_room_id])
    if @remember.save
      render json: { success: true }
    else
      render json: { success: false }
    end
  end

  def add_confirm
    @user_chat_rooms = @chat_room.remembers
    if @user_chat_rooms
      render json: { success: true, user_chat_rooms: @user_chat_rooms }
    end
  end

  private
  def create_chat_user1_user2(user, chat_room_name)
    single_room = ChatRoom.create(title: chat_room_name)
    Remember.create(user_id: current_user.id, chat_room_id: single_room.id)
    Remember.create(user_id: user.id, chat_room_id: single_room.id)
    single_room
  end

  def get_name(user1, user2)
    users = [user1, user2].sort
    "private_#{users[0].id}_#{users[1].id}"
  end

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
    current_user.remembers.map do |remember|
      ChatRoom.find(remember.chat_room_id)
    end.reject { |chat_room| chat_room.title.start_with?('private_') }
  end
end
