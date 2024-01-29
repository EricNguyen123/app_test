# frozen_string_literal: true

# spec/controllers/confirmations_controller_spec.rb
require 'rails_helper'

RSpec.describe ConfirmationsController, type: :controller do
  describe 'GET #show' do
    let(:user) { FactoryBot.create(:user) }

    context 'with valid confirmation token' do
      before do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        get :show, params: { confirmation_token: user.confirmation_token }
      end

      it 'confirms the user' do
        expect(user.reload.confirmed?).to be true
      end

      it 'signs the user in' do
        expect(controller.current_user).to eq(user)
      end

      it 'redirects to the user page' do
        expect(response).to redirect_to(user_path(user))
      end
    end

    context 'with invalid confirmation token' do
      before do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        get :show, params: { confirmation_token: 'invalid_token' }
      end

      it 'does not confirm the user' do
        expect(user.reload.confirmed?).to be false
      end

      it 'does not sign the user in' do
        expect(controller.current_user).to be_nil
      end

      it 'renders the new template' do
        expect(response).to render_template(:new)
      end
    end

    context 'with valid confirmation token' do
      before do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        get :show, params: { confirmation_token: user.confirmation_token }
      end

      it 'signs the user in after confirmation' do
        expect(controller.current_user).to eq(user)
      end

      it 'redirects to the root path after confirmation' do
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
