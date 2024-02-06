# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DestroyMessageJob, type: :job do
  include ActiveJob::TestHelper

  let(:user) { FactoryBot.create(:user) }
  let(:chat_room) { FactoryBot.create(:chat_room) }
  let(:message) { FactoryBot.create(:message, user:, chat_room:) }

  describe '#perform_later' do
    it 'queues the job' do
      expect do
        DestroyMessageJob.perform_later(message)
      end.to have_enqueued_job(DestroyMessageJob).with(message)
    end
  end

  describe '#perform' do
    it 'broadcasts the message' do
      allow(ActionCable.server).to receive(:broadcast)

      perform_enqueued_jobs do
        DestroyMessageJob.perform_later(message)
      end
    end
  end
end