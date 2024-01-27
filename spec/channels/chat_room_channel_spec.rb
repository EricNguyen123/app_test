# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChatRoomChannel, type: :channel do
  let(:chat_room) { FactoryBot.create(:chat_room) } # Giả sử bạn đã định nghĩa factory cho ChatRoom

  describe '#subscribed' do
    context 'when chat_room_id is provided' do
      it 'successfully subscribes' do
        subscribe(chat_room_id: chat_room.id)
        expect(subscription).to be_confirmed
        expect(subscription).to have_stream_from("chat_room_channel_#{chat_room.id}")
      end
    end

    context 'when chat_room_id is not provided' do
      it 'rejects the subscription' do
        subscribe
        expect(subscription).to be_rejected
      end
    end
  end

  describe '#unsubscribed' do
    it 'successfully unsubscribes' do
      subscribe(chat_room_id: chat_room.id)
      unsubscribe
      expect(subscription).not_to have_streams
    end
  end
end
