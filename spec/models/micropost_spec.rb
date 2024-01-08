# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:micropost) { FactoryBot.create(:micropost, user:) }

  it "should be valid" do
    expect(micropost.valid?).to be true
  end

  it "user id should be present" do
    micropost.user_id = nil
    expect(micropost.valid?).to be false
  end

  it "content should be present" do
    micropost.content = "   "
    expect(micropost.valid?).to be false
  end

  it "content should be at most 140 characters" do
    micropost.content = "a" * 141
    expect(micropost.valid?).to be false
  end

  it "order should be most recent first" do
    most_recent_micropost = user.microposts.create!(content: micropost.content)
    expect(Micropost.first).to eq most_recent_micropost
  end

  it "deletes the micropost and associated comments when a micropost is deleted" do
    micropost = FactoryBot.create(:micropost, user:)
    micropost = user.microposts.create!(content: micropost.content)
    comment1 = micropost.microposts.create!(content: micropost.content, user: user)
    comment2 = micropost.microposts.create!(content: micropost.content, user: user)

    expect(Micropost.where(id: micropost.id)).to exist
    expect(Micropost.where(id: comment1.id)).to exist
    expect(Micropost.where(id: comment2.id)).to exist

    micropost.destroy

    expect(Micropost.where(id: micropost.id)).not_to exist
    expect(Micropost.where(id: comment1.id)).not_to exist
    expect(Micropost.where(id: comment2.id)).not_to exist
  end
  

end
