# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:micropost) { FactoryBot.create(:micropost, user:) }

  it { should belong_to(:user) }

  it { should validate_presence_of(:content) }

  it { should validate_presence_of(:user_id) }

  it { should validate_presence_of(:content).with_message("can't be blank") }

  it { should validate_length_of(:content).is_at_most(140).with_long_message('is too long (maximum is 140 characters)') }

  it 'order should be most recent first' do
    most_recent_micropost = user.microposts.create!(content: micropost.content)
    expect(Micropost.first).to eq most_recent_micropost
  end

  it 'deletes the micropost and associated comments when a micropost is deleted' do
    micropost = FactoryBot.create(:micropost, user:)
    micropost = user.microposts.create!(content: micropost.content)
    comment1 = micropost.microposts.create!(content: micropost.content, user:)
    comment2 = micropost.microposts.create!(content: micropost.content, user:)

    expect(Micropost.where(id: micropost.id)).to exist
    expect(Micropost.where(id: comment1.id)).to exist
    expect(Micropost.where(id: comment2.id)).to exist

    micropost.destroy

    expect(Micropost.where(id: micropost.id)).not_to exist
    expect(Micropost.where(id: comment1.id)).not_to exist
    expect(Micropost.where(id: comment2.id)).not_to exist
  end
end
