Rails.application.routes.draw do
  resources :folders
  get 'home/index'

  root 'home#index'

  get '/login' => 'auth#new', as: :login
  post '/login' => 'auth#login'
  get '/logout' => 'auth#logout', as: :logout

  get '/filter' => 'tasks#filter', as: :filter
  get '/search' => 'tasks#search', as: :search
  get '/mass_assign' => 'tasks#mass_assign', as: :mass_assign

  resources :users, except: [:index]

  resources :inboxes do
    resources :items, except: [:index]
    member do
      get 'develop' => 'develop#develop', as: :develop
    end
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
      end
    end
  end
  resources :tasks, only: [:index] #independent Task index
  resources :locations
  resources :tags

  resources :folders do
    resources :ref_items, except: [:index]
  end

  resources :checklists

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
