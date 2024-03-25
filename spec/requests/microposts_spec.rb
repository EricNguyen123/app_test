# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Microposts', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:token) do
    post user_session_path, params: { user: { email: user.email, password: user.password } }
    response.headers['Authorization']
  end
  let(:micropost) { FactoryBot.create(:micropost, user:) }

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Micropost' do
        expect do
          post microposts_path, params: { micropost: }, headers: { 'Authorization': "Bearer #{token}" }
        end.to change(Micropost, :count).by(1)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested micropost' do
      expect do
        delete microposts_path(micropost), headers: { 'Authorization': "Bearer #{token}" }
      end.to change(Micropost, :count).by(-1)
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      it 'updates the requested micropost' do
        allow(Micropost).to receive(:find_by).and_return(micropost)
        patch microposts_path(micropost), headers: { 'Authorization': "Bearer #{token}" }
        micropost.reload
        expect(micropost.content).to eql(new_attributes[:content])
      end
    end
  end
end
