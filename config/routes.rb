Rails.application.routes.draw do
  resources :inboxes
  resources :users
  get 'home/index'

  root 'home#index'

  get '/login' => 'auth#new', as: :login
  post '/login' => 'auth#login'
  get '/logout' => 'auth#logout', as: :logout

  resources :users, only: [:new]
  resources :inboxes

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
