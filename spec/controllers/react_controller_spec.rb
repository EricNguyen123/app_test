# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReactsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:micropost) { FactoryBot.create(:micropost, user:) }
  let(:valid_attributes) { { user_id: user.id, micropost_id: micropost.id, action: 'like' } }
  let(:invalid_attributes) { { user_id: nil, micropost_id: nil, action: nil } }
  let(:react) { FactoryBot.create(:react, action: 'like', user:, micropost:) }

  describe 'POST #create' do
    context 'with valid params' do
      before { log_in user }
      it 'creates a new React' do
        expect do
          post :create, params: { react: valid_attributes }
        end.to change(React, :count).by(1)
        expect(response).to be_successful
        expect(React.find_by(user_id: user.id, micropost_id: micropost.id)[:action]).to eq(valid_attributes[:action])
      end

      it 'does not create a new React' do
        allow_any_instance_of(React).to receive(:save).and_return(false)
        post :create, params: { react: valid_attributes }
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['success']).to eq(false)
        expect(json_response['status']).to eq('error')
      end
    end

    context 'with invalid params' do
      before { log_in user }
      it 'does not create a new React if micropost_id does not exist' do
        expect do
          post :create, params: { react: invalid_attributes }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#react_update' do
    context 'when react exists' do
      before { log_in user }
      it 'updates the react' do
        params = ActionController::Parameters.new(react: { action: 'new_action', micropost_id: micropost.id, user_id: user.id })
        allow(controller).to receive(:params).and_return(params)
        allow(controller).to receive(:react_exists?).and_return(react)

        expect(react).to receive(:update).with(params[:react].permit!).and_return(true)

        controller.send(:react_update)
      end

      it 'renders json error when update fails' do
        params = ActionController::Parameters.new(react: { action: 'new_action', micropost_id: micropost.id, user_id: user.id })
        allow(controller).to receive(:params).and_return(params)
        allow(controller).to receive(:react_exists?).and_return(react)

        expect(react).to receive(:update).with(params[:react].to_unsafe_h).and_return(false)
        expect(controller).to receive(:render).with(json: { success: false, status: 'error' })

        controller.send(:react_update)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when react exists' do
      before { log_in user }
      it 'destroys the react' do
        react = micropost.reacts.create!(action: 'like', user_id: user.id, micropost_id: micropost.id)
        expect do
          delete :destroy, params: { id: react.id, react: { id: react.id, action: 'like', user_id: user.id, micropost_id: micropost.id } }
        end.to change(React, :count).by(-1)

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['success']).to eq(true)
        expect(json_response['status']).to eq('success')
      end
    end

    context 'when react does not exist' do
      before { log_in user }
      it 'does not destroy the react' do
        expect do
          delete :destroy, params: { id: 9999, react: { id: 9999, action: 'like', user_id: user.id, micropost_id: micropost.id } }
        end.to_not change(React, :count)

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['success']).to eq(false)
        expect(json_response['status']).to eq('error')
      end

      it 'does not destroy the react if destroy method returns false' do
        react = micropost.reacts.create!(action: 'like', user_id: user.id, micropost_id: micropost.id)
        allow_any_instance_of(React).to receive(:destroy).and_return(false)

        expect do
          delete :destroy, params: { id: react.id, react: { id: react.id, action: 'like', user_id: user.id, micropost_id: micropost.id } }
        end.to_not change(React, :count)

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['success']).to eq(false)
        expect(json_response['status']).to eq('error')
      end
    end
  end
end
