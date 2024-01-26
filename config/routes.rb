# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do

  mount Sidekiq::Web => '/sidekiq'

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
  resources :chat_rooms do
    resources :messages
  end
  get '/user_chat/:id', to: 'chat_rooms#create_chat_room_user'
  post '/add_user/:user_id/:chat_room_id', to: 'chat_rooms#add_room_for_user'
  get '/add_confirm/:id', to: 'chat_rooms#add_confirm'
  mount ActionCable.server, at: '/cable'
end
