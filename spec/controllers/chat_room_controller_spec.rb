# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChatRoomsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:chat_room) { FactoryBot.create(:chat_room) }
  let(:current_user) { FactoryBot.create(:user) }

  before { log_in user }

  describe 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'assigns chat_rooms, chat_room, and user_chats' do
      get :index
      expect(assigns(:chat_rooms)).to be_a_kind_of(Array)
      expect(assigns(:chat_room)).to be_a(ChatRoom)
      expect(assigns(:user_chats)).to be_a_kind_of(Array)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new chat room and remember record' do
        expect do
          post :create, params: { chat_room: { title: 'myString' } }
        end.to change(ChatRoom, :count).by(1).and change(RememberRoom, :count).by(1)
      end
    end

    context 'with invalid parameters' do
      it 'renders the index template with an error message' do
        allow(ChatRoom).to receive(:create).and_raise(ActiveRecord::RecordInvalid)

        post :create, params: { chat_room: { title: 'Invalid Room' } }

        expect(flash[:error]).to be_present
        expect(response).to redirect_to(chat_rooms_path)
      end
    end
  end

  describe 'GET #show' do
    it 'renders the index template' do
      get :show, params: { id: chat_room.id }
      expect(response).to render_template(:index)
    end

    it 'assigns single_room, chat_rooms, and user_chats' do
      get :show, params: { id: chat_room.id }
      expect(assigns(:single_room)).to eq(chat_room)
      expect(assigns(:chat_rooms)).to be_a_kind_of(Array)
      expect(assigns(:user_chats)).to be_a_kind_of(Array)
    end
  end

  describe 'DELETE #destroy' do
    let(:chat_room) { FactoryBot.create(:chat_room) }
    context 'when chat room is successfully destroyed' do
      it 'returns a successful response' do
        delete :destroy, params: { id: chat_room.id }, format: :turbo_stream
        expect(ChatRoom.find_by(id: chat_room.id)).to be_nil
      end
    end

    context 'when chat room cannot be destroyed' do
      it 'does not delete the chat room' do
        allow_any_instance_of(ChatRoom).to receive(:destroy).and_raise(ActiveRecord::RecordNotDestroyed)
        delete :destroy, params: { id: chat_room.id }
        expect(flash[:error]).to eq('Chat Room could not be deleted')
        expect(response).to redirect_to(chat_rooms_path)
      end
    end
  end

  describe 'POST #create_chat_room_user' do
    context 'when chat room does not exist' do
      it 'creates a new chat room' do
        allow(controller).to receive(:current_user).and_return(current_user)
        allow(controller).to receive(:get_name).and_return('chat_room_name')
        expect do
          post :create_chat_room_user, params: { id: user.id }
        end.to change(ChatRoom, :count).by(1)
        expect(response).to render_template('index')
      end
    end
  end

  describe 'POST #add_room_for_user' do
    context 'when remember is successfully created' do
      before do
        remember = double('RememberRoom')
        allow(remember).to receive(:save).and_return(true)
        allow(RememberRoom).to receive(:create).and_return(remember)
      end

      it 'returns a successful response' do
        post :add_room_for_user, params: { user_id: user.id, chat_room_id: chat_room.id }
        expect(response.body).to eq({ success: true }.to_json)
      end
    end

    context 'when remember cannot be created' do

      it 'returns an unsuccessful response' do
        allow_any_instance_of(RememberRoom).to receive(:save).and_return(false)
        post :add_room_for_user, params: { user_id: user.id, chat_room_id: chat_room.id }
        expect(response.body).to eq({ success: false }.to_json)
      end
    end
  end

  describe '#add_confirm' do
    context 'when chat room has remember_rooms' do
      before do
        allow(chat_room).to receive(:remember_rooms).and_return(true)
        get :add_confirm, params: { id: chat_room.id }
      end

      it 'returns success true' do
        expect(JSON.parse(response.body)['success']).to eq(true)
      end
    end

    context 'when chat room has no remember_rooms' do
      before do
        allow(ChatRoom).to receive(:find).and_return(chat_room)
        allow(chat_room).to receive(:remember_rooms).and_return(nil)
        get :add_confirm, params: { id: chat_room.id }
      end

      it 'returns success false' do
        expect(JSON.parse(response.body)['success']).to eq(false)
      end
    end
  end

  let(:user1) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user) }

  describe '#get_name' do
    it 'returns the correct name' do
      expected_name = "private_#{[user1.id, user2.id].min}_#{[user1.id, user2.id].max}"
      expect(controller.send(:get_name, user1, user2)).to eq(expected_name)
    end
  end

  let(:chat_room1) { FactoryBot.create(:chat_room, title: 'private_chat') }
  let(:chat_room2) { FactoryBot.create(:chat_room, title: 'public_chat') }
  let(:remember1) { FactoryBot.create(:remember_room, user:, chat_room: chat_room1) }
  let(:remember2) { FactoryBot.create(:remember_room, user:, chat_room: chat_room2) }
  before do
    allow(controller).to receive(:current_user).and_return(user)
    allow(user).to receive(:remember_rooms).and_return([remember1, remember2])
  end

  describe '#find_all_chat_room' do
    it 'returns all non-private chat rooms' do
      expect(controller.send(:find_all_chat_room)).to eq([chat_room2])
    end
  end
end
