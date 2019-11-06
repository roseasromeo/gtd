Rails.application.routes.draw do
  resources :tags
  resources :tasks
  resources :locations
  resources :projects
  resources :items
  resources :inboxes
  resources :users
  get 'home/index'

  root 'home#index'

  get '/login' => 'auth#new', as: :login
  post '/login' => 'auth#login'
  get '/logout' => 'auth#logout', as: :logout

  resources :users, only: [:new]

  resources :inboxes do
    resources :items, except: [:index]
  end

  resources :projects do
    member do
      get 'archive'
      get 'unarchive'
    end
    resources :tasks, except: [:index] do
      member do
        get 'complete'
        get 'uncomplete'
        get 'edit_tags'
        post 'edit_tags', as: :add_tags
      end
    end
  end
  resources :locations

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
