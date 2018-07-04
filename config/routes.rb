Rails.application.routes.draw do
  resources :chats
  resources :participants
  devise_for :users

  root 'chat_rooms#index'
  resources :users
  resources :chat_rooms

  get '/chat_rooms/choose/:id/:user_id', to: 'chat_rooms#choose'

  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
