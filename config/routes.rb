Rails.application.routes.draw do
  resources :chats
  resources :participants
  devise_for :users

  root 'chat_rooms#index'
  resources :users
  resources :chat_rooms

  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
