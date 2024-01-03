# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MicropostsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:micropost) { FactoryBot.create(:micropost, user:) }
  describe 'POST #create' do
    context 'when user is logged in' do
      before { log_in user }

      it 'creates a comment' do
        post :create, params: { micropost: { micropost_id: micropost.id, user_id: user.id } }
        expect(assigns(:micropost)).to be_a_new(Micropost)
      end

      it 'attaches an image to the micropost' do
        image = fixture_file_upload('imgtest.png', 'image/jpeg')
        post :create, params: { micropost: { micropost_id: micropost.id, image: } }
        expect(assigns(:micropost).image).to be_attached
        # Add more expectations as needed for image attachment
      end

      it 'redirects to home after successful micropost creation' do
        post :create, params: { micropost: { micropost_id: micropost.id, user_id: micropost.user_id } }
        expect(response).to render_template('static_pages/home')
      end

      it 'creates a micropost' do
        post :create, params: { micropost: { content: micropost.content, user_id: micropost.user_id } }
        expect(response).to redirect_to(root_url)
        expect(flash[:success]).to eq('Micropost created!')
      end

      it 'does not create a micropost' do
        post :create, params: { micropost: { content: nil } }
        expect(response).to render_template('static_pages/home')
      end

      # Add more tests for other scenarios as needed
    end
  end

  describe 'DELETE #destroy' do
    let(:micropost) { FactoryBot.create(:micropost, user:) }

    context 'when micropost exists' do
      before { log_in user }

      it 'deletes the micropost' do
        delete :destroy, params: { id: micropost.id }
        expect(response).to redirect_to(root_url)
        expect(flash[:success]).to eq('Micropost deleted')
      end

      # Add more tests for other scenarios as needed
    end

    context 'when micropost does not exist' do
      before { log_in user }

      it 'does not delete the micropost' do
        delete :destroy, params: { id: -1 }
        expect(response).to redirect_to(root_url)
      end

      # Add more tests for other scenarios as needed
    end
  end
end
