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

      it 'does not save comment if micropost_id is not provided' do
        micropost_params = { micropost: { content: micropost.content } }
        post :create, params: micropost_params
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe 'UPDATE #update' do
    before { log_in user }
    it 'updates the micropost and redirects to root_url' do
      allow(Micropost).to receive(:find_by).and_return(micropost)
      patch :update, params: { micropost_id: micropost.micropost_id, id: micropost.id, micropost: { id: micropost.id, content: micropost.content, user_id: user.id } }

      expect(micropost.reload.content).to eq(micropost.content)
      expect(flash[:success]).to eq('Micropost updated!')
      expect(response).to redirect_to(root_url)
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

      it 'deletes the micropost and associated comments when a micropost is deleted' do
        comment = micropost.microposts.create(micropost_id: micropost.id, user_id: user.id)
        delete :destroy, params: { id: micropost.id }
        expect(response).to redirect_to(root_url)
        expect(flash[:success]).to eq('Micropost deleted')
        orphan_comment = Micropost.find_by(id: comment.id)
        expect(orphan_comment).to eq(nil)
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
