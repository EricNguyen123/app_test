# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChatRoom, type: :model do
  let(:chat_room) { FactoryBot.create(:chat_room) }
  let(:user) { FactoryBot.create(:user) }
  let(:remember_room) { FactoryBot.create(:remember_room, user:, chat_room:) }

  it { should have_many(:messages).dependent(:destroy) }
  it { should have_many(:remember_rooms).dependent(:destroy) }

  it { should validate_presence_of(:title) }

  describe '#remember_rooms?' do
    context 'when the user is remembered in the chat room' do
      before do
        remember_room
      end

      it 'returns true' do
        expect(chat_room.remember_rooms?(chat_room, user)).to eq(true)
      end
    end

    context 'when the user is not remembered in the chat room' do
      it 'returns false' do
        expect(chat_room.remember_rooms?(chat_room, user)).to eq(false)
      end
    end
  end
end
