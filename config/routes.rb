Rails.application.routes.draw do
  devise_for :users

  resources :users, only: [:index]
  resources :conversations, only: [:index, :show]
  resources :personal_messages, only: [:new, :create]

  root 'conversations#index'
end
