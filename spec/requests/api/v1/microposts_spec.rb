# frozen_string_literal: true

# spec/controllers/api/v1/microposts_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::MicropostsController, type: :controller do
  let(:user) { FactoryBot.create(:user, confirmed_at: Time.now.utc) }
  let(:micropost) { FactoryBot.create(:micropost, user:) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index, format: :json
      expect(response).to have_http_status(:success)
    end

    it 'returns all the microposts' do
      microposts = FactoryBot.create_list(:micropost, 3, user:)
      get :index, format: :json
      result = JSON.parse(response.body)
      expect(result.size).to eq(3)
      expect(result.map { |m| m['id'] }).to match_array(microposts.map(&:id))
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'renders a json response with the new micropost and status 200' do
        post :create, params: { micropost: { content: micropost.content, user_id: user.id } }, format: :json
        comment = Micropost.find_by(user_id: user.id)
        expect(comment.content).to eq(micropost.content)
        expect(comment.user_id).to eq(micropost.user_id)
        result = JSON.parse(response.body)
        expect(result['id']).to eq(comment.id)
        expect(result['content']).to eq(comment.content)
        expect(response).to have_http_status(200)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new micropost' do
        expect { post :create, params: { micropost: { content: nil } }, format: :json }.not_to change(Micropost, :count)
      end

      it 'renders a json response with error message' do
        post :create, params: { micropost: { content: nil } }, format: :json
        result = JSON.parse(response.body)
        expect(result['messages']).to eq('Error save')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:micropost) { FactoryBot.create(:micropost, user:) }

    context 'when the micropost is successfully destroyed' do
      it 'decreases the micropost count by 1' do
        post :create, params: { micropost: { content: micropost.content, user_id: user.id } }, format: :json
        comment = Micropost.find_by(user_id: user.id)
        expect { delete :destroy, params: { id: comment.id }, format: :json }.to change(Micropost, :count).by(-1)
      end

      it 'renders a json response with success message and status 200' do
        delete :destroy, params: { id: micropost.id }, format: :json
        result = JSON.parse(response.body)
        expect(result['messages']).to eq('Success destroy')
        expect(result['status']).to eq(200)
      end
    end

    context 'when the micropost is not destroyed' do
      before do
        allow_any_instance_of(Micropost).to receive(:destroy!).and_raise(ActiveRecord::RecordNotDestroyed)
      end

      it 'does not change the micropost count' do
        micropost
        expect { delete :destroy, params: { id: micropost.id }, format: :json }.not_to change(Micropost, :count)
      end

      it 'renders a json response with error message and status 400' do
        delete :destroy, params: { id: micropost.id }, format: :json
        result = JSON.parse(response.body)
        expect(result['messages']).to eq('Error destroy')
        expect(result['status']).to eq(400)
      end
    end
  end

  describe 'PATCH #update' do
    context 'when the micropost is successfully updated' do
      it 'updates the micropost attributes' do
        allow(Micropost).to receive(:find_by).and_return(micropost)
        patch :update, params: { micropost_id: micropost.micropost_id, id: micropost.id, micropost: { id: micropost.id, content: micropost.content, user_id: user.id } }, format: :json
        expect(response).to have_http_status(200)
        expect(micropost.reload.content).to eq(micropost.content)
      end
    end

    context 'when the micropost is not updated' do
      before do
        allow_any_instance_of(Micropost).to receive(:update).and_return(false)
      end

      it 'renders a json response with error message and status 400' do
        allow(Micropost).to receive(:find_by).and_return(micropost)
        patch :update, params: { micropost_id: micropost.micropost_id, id: micropost.id, micropost: { id: micropost.id, content: micropost.content, user_id: user.id } }, format: :json
        result = JSON.parse(response.body)
        expect(result['status']).to eq(400)
      end
    end
  end
end
