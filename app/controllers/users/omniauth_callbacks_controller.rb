# frozen_string_literal: true

# model users
module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def github
      handle_auth 'Github'
    end

    def google_oauth2
      handle_auth 'Google'
    end

    def facebook
      handle_auth 'Facebook'
    end

    def handle_auth(kind)
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user && @user.persisted?
        flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind:)
        sign_in_and_redirect @user, event: :authentication
      else
        session['devise.auth_data'] = request.env['omniauth.auth']&.except('extra')
        redirect_to new_user_registration_path, alert: @user&.errors&.full_messages&.join("\n")
      end
    end
  end
end
