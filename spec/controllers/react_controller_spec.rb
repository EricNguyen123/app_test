require 'rails_helper'

RSpec.describe ReactsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:micropost) { FactoryBot.create(:micropost, user:) }
  let(:valid_attributes) { { user_id: user.id, micropost_id: micropost.id, action: 'like' } }
  let(:invalid_attributes) { { user_id: nil, micropost_id: nil, action: nil } }

  describe "POST #create" do
    context "with valid params" do
      before { log_in user }
      it "creates a new React" do
        expect {
          post :create, params: { react: valid_attributes }
        }.to change(React, :count).by(1)
      end

      it "renders a successful response" do
        post :create, params: { react: valid_attributes }
        expect(response).to be_successful
      end

      it "does not create a new React" do
        allow_any_instance_of(React).to receive(:save).and_return(false)
        post :create, params: { react: valid_attributes }
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['success']).to eq(false)
        expect(json_response['status']).to eq('error')
      end
    end

    context "with invalid params" do
      before { log_in user }
      it "does not create a new React if micropost_id does not exist" do
        expect {
          post :create, params: { react: invalid_attributes }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when react exists' do
      before { log_in user }
      it 'destroys the react' do
        react = micropost.reacts.create!(action: 'like', user_id: user.id, micropost_id: micropost.id)
        expect {
          delete :destroy, params: { id: react.id, react: { id: react.id, action: 'like', user_id: user.id, micropost_id: micropost.id } }
        }.to change(React, :count).by(-1)

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['success']).to eq(true)
        expect(json_response['status']).to eq('success')
      end
    end

    context 'when react does not exist' do
      before { log_in user }
      it 'does not destroy the react' do
        expect {
          delete :destroy, params: { id: 9999, react: { id: 9999, action: 'like', user_id: user.id, micropost_id: micropost.id } }
        }.to_not change(React, :count)

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['success']).to eq(false)
        expect(json_response['status']).to eq('error')
      end

      it 'does not destroy the react if destroy method returns false' do
        react = micropost.reacts.create!(action: 'like', user_id: user.id, micropost_id: micropost.id)
        allow_any_instance_of(React).to receive(:destroy).and_return(false)
      
        expect {
          delete :destroy, params: { id: react.id, react: { id: react.id, action: 'like', user_id: user.id, micropost_id: micropost.id } }
        }.to_not change(React, :count)
      
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['success']).to eq(false)
        expect(json_response['status']).to eq('error')
      end
    end
  end
end
