# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, controllers: {
    confirmations: 'confirmations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  mount Sidekiq::Web => '/sidekiq'

  root 'static_pages#home'

  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

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

  namespace :api do
    namespace :v1 do 
      resources :microposts, only: [:index, :create, :update, :destroy, :show]
    end
  end
end
