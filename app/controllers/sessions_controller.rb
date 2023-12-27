# frozen_string_literal: true

# Controller managing user sessions.
class SessionsController < ApplicationController
  def new
    @items = [
      { links: '/auth/google_oauth2', name: 'Google', image: 'google-18px.svg' },
      { links: '/auth/facebook', name: 'Facebook', image: 'facebook-18px.svg' },
      { links: '/auth/github', name: 'Github', image: 'github-18px.svg' }
    ]
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_to user
      else
        message = 'Account not activated. '
        message += 'Check your email for the activation link.'
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      # Create an error message.
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def omniauth
    user = User.new.login_with_third_party(request.env)
    if user.valid?
      user.activate unless user.activated?
      log_in user
      redirect_to root_url
    else
      redirect_to login_path
    end
  end
end
