# frozen_string_literal: true

Rails.application.routes.draw do
  root 'static_pages#home'
  devise_for :users
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'
  get 'users/new'

  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'

  delete '/logout',  to: 'sessions#destroy'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'

  get '/auth/:provider/callback', to: 'sessions#omniauth'

  get '/settings', to: 'users#edit'

  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :microposts do
    resources :microposts
  end
  resources :reacts, only: %i[create destroy update]
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: %i[new create edit update]
  resources :microposts, only: %i[create destroy update]
  resources :relationships, only: %i[create destroy]
  resources :chat_rooms
end
