# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MicropostsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:micropost) { FactoryBot.create(:micropost, user:) }
  describe 'POST #create' do
    context 'when user is logged in' do
      before { log_in user }

      it 'creates a comment' do
        expect do
          post :create, params: { micropost: { micropost_id: micropost.id, user_id: user.id } }
        end.to change(Micropost, :count).by(1)

        post :create, params: { micropost: { micropost_id: micropost.id, user_id: user.id } }
        expect(assigns(:micropost)).to be_a_new(Micropost)
      end

      it 'attaches an image to the micropost' do
        img = fixture_file_upload('imgtest.png', 'image/jpeg')
        post :create, params: { micropost: { micropost_id: micropost.id, image: img } }
        expect(assigns(:micropost)).to be_present
        expect(assigns(:micropost).image).to be_attached
      end

      it 'redirects to home after not successful micropost creation' do
        post :create, params: { micropost: { micropost_id: micropost.id, user_id: micropost.user_id } }
        expect(response).to render_template('static_pages/home')
      end

      it 'creates a micropost' do
        post :create, params: { micropost: { content: micropost.content, user_id: micropost.user_id } }
        expect(response).to redirect_to(root_url)
        expect(flash[:success]).to eq('Micropost created!')
        comment = Micropost.find_by(user_id: user.id)
        expect(comment.content).to eq(micropost.content)
        expect(comment.user_id).to eq(micropost.user_id)
      end

      it 'does not create a micropost' do
        post :create, params: { micropost: { content: nil } }
        expect(response).to render_template('static_pages/home')
        expect do
          post :create, params: { micropost: { content: nil } }
        end.to change(Micropost, :count).by(0)
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
        comment = Micropost.find_by(id: micropost.id)
        expect(comment).to eq(nil)
      end
    end

    context 'when micropost does not exist' do
      before { log_in user }

      it 'does not delete the micropost' do
        delete :destroy, params: { id: -1 }
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
