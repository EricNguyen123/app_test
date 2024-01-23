# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:chat_room) { FactoryBot.create(:chat_room) }
  let(:message) { FactoryBot.create(:message, user:, chat_room:) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    allow(controller).to receive(:logged_in_user).and_return(true)
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new message' do
        expect do
          post :create, params: { message: { message: 'Hello, world!' }, chat_room_id: chat_room.id }
        end.to change(Message, :count).by(1)
      end
    end
  end

  describe 'PATCH #update' do
    context 'when the update is successful' do
      let(:params) { { message: 'New message content' } }

      it 'updates the message' do
        patch :update, params: { chat_room_id: chat_room.id, id: message.id, message: params[:message] }
        message.reload
        expect(message.message).to eq(params[:message])
        expect(response.body).to eq({ success: true }.to_json)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { message }

    it 'deletes the message' do
      expect do
        delete :destroy, params: { chat_room_id: chat_room.id, id: message.id }, format: :turbo_stream
      end.to change(Message, :count).by(-1)
    end

    it 'does not delete the chat room' do
      allow_any_instance_of(Message).to receive(:destroy).and_raise(ActiveRecord::RecordNotDestroyed)
      delete :destroy, params: { chat_room_id: chat_room.id, id: message.id }
      expect(flash[:error]).to eq('Message could not be deleted')
      expect(response).to redirect_to(root_url)
    end
  end
end
