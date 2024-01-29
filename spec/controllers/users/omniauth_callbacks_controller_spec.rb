# spec/controllers/users/omniauth_callbacks_controller_spec.rb
require 'rails_helper'
require 'devise'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:github] 
  end

  describe '#github' do
    context 'when the user persists' do
      before do
        allow(User).to receive(:from_omniauth).and_return(FactoryBot.create(:user))
        post :github
      end

      it 'completes user registration' do
        expect(User.count).to eq(1)
      end

    end

    context 'when the user does not persist' do
      before do
        allow(User).to receive(:from_omniauth).and_return(User.new)
        post :github
      end

      it 'does not create a new user' do
        expect(User.count).to eq(0)
      end

      it 'redirects to the new user registration url' do
        expect(response).to redirect_to new_user_registration_url
      end
    end
  end

end
