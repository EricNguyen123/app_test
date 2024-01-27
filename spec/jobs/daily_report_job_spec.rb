# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe DailyReportJob, type: :worker do
  let(:user) { FactoryBot.create(:user) }
  let(:micropost1) { FactoryBot.create(:micropost, user:) }
  let(:micropost) { FactoryBot.create(:micropost, user:) }
  let(:comment1) { FactoryBot.create(:micropost, user:, micropost_id: micropost.id) }
  let(:comment2) { FactoryBot.create(:micropost, user:, micropost_id: comment1.id) }

  before do
    Sidekiq::Testing.fake!
    comment1
    comment2
    allow(Micropost).to receive(:microposts_yesterday).and_return([micropost, micropost1])
  end

  it 'queues the job' do
    expect { DailyReportJob.perform_async }.to change(DailyReportJob.jobs, :size).by(1)
  end

  it 'executes perform' do
    expect_any_instance_of(Slack::Web::Client).to receive(:chat_postMessage)
    DailyReportJob.new.perform
  end

  it 'returns the most commented post' do
    worker = DailyReportJob.new
    expect(worker.most_commented_post).to eq([micropost])
  end

  it 'counts the number of comments for a micropost' do
    worker = DailyReportJob.new
    expect(worker.count_commented_posts(micropost, 0)).to eq(2)
  end

  after do
    Sidekiq::Worker.clear_all
  end
end
