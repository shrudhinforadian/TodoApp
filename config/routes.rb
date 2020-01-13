# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users
  resources :sessions
  resources :todos
  resources :users do
    resources :todos
    get:active
  end
  get "todos/search"
  resources :todos do

    member do
      post :activate
      post :up
      post :down
    end
  end
  resources :users do
    member do
      get :confirm_email
    end
  end
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  root 'todos#index'
  resources :entries, defaults: { format: 'json' }
  # get "/active/:id", to: "controller#active", as: :active
end
