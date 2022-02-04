Rails.application.routes.draw do
  get 'sessions/new'
  get 'sessions/index'
  get 'users/new'
  root 'static_pages#home'
  get :about,        to: 'static_pages#about'
  get :use_of_terms, to: 'static_pages#terms'
  get :signup,  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get '/recruit_login', to: 'sessions#index'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :problems, only: [:question] do
    member do
      get 'question'
      patch 'answer'
      get 'answer', to: redirect('/')
    end
  end
  resources :problems
  resources :relationships, only: [:create, :destroy]
  get :favorites, to: 'favorites#index'
  post "favorites/:problem_id/create" => "favorites#create"
  delete "favorites/:problem_id/destroy" => "favorites#destroy"
  resources :comments, only: [:create, :destroy]
  resources :notifications, only: :index
 end