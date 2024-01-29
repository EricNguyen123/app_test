# frozen_string_literal: true

# Helper session
module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user?(user)
    user && user == current_user
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def icon_login_with_third_party(title)
    items = {
      'GoogleOauth2' => { name: 'Google', image: 'google-18px.svg' },
      'Facebook' => { name: 'Facebook', image: 'facebook-18px.svg' },
      'GitHub' => { name: 'Github', image: 'github-18px.svg' }
    }
    items[title]
  end
end
