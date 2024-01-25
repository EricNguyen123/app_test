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

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'POST #create' do
    context 'when the message is valid' do
      it 'creates a new message and enqueues a job' do
        expect do
          post :create, params: { message: { message: 'Hello, world!' }, chat_room_id: chat_room.id }
        end.to change(Message, :count).by(1)
                                      .and have_enqueued_job(CreateMessageJob)
      end
    end

    context 'when the message is invalid' do
      it 'does not create a message' do
        allow_any_instance_of(Message).to receive(:save).and_raise(ActiveRecord::RecordInvalid)
        expect do
          post :create, params: { message: { message: 'Hello, world!' }, chat_room_id: chat_room.id }
        end.not_to change(Message, :count)
      end

      it 'does not enqueue a job' do
        allow_any_instance_of(Message).to receive(:save).and_raise(ActiveRecord::RecordInvalid)
        expect do
          post :create, params: { message: { message: 'Hello, world!' }, chat_room_id: chat_room.id }
        end.not_to have_enqueued_job(CreateMessageJob)
      end

      it 'sets a flash error and redirects' do
        allow_any_instance_of(Message).to receive(:save).and_raise(ActiveRecord::RecordInvalid)
        post :create, params: { message: { message: 'Hello, world!' }, chat_room_id: chat_room.id }
        expect(flash[:error]).to eq('Message could not be created')
        expect(response).to redirect_to(request.referrer || root_url)
      end
    end
  end

  describe 'PATCH #update' do
    context 'when the update is successful' do
      let(:params) { { message: 'New message content' } }
      it 'updates the message and enqueues a job' do
        expect do
          patch :update, params: { chat_room_id: chat_room.id, id: message.id, message: params[:message] }
        end.to have_enqueued_job(UpdateMessageJob).with(message)

        message.reload
        expect(message.message).to eq(params[:message])
      end
    end

    context 'when the update fails' do
      let(:params) { { message: 'New message content' } }
      it 'does not update the message or enqueue a job' do
        allow_any_instance_of(Message).to receive(:update).and_return(false)

        expect do
          patch :update, params: { chat_room_id: chat_room.id, id: message.id, message: params[:message] }
        end.not_to have_enqueued_job(UpdateMessageJob)

        expect(response).to redirect_to(request.referrer || root_url)
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
