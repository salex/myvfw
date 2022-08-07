Rails.application.routes.draw do
  namespace :entries do
    resources :duplicate, only: [:show]
    resources :void, only: [:show, :update]
    resources :search, only: [:edit, :update]
    resources :filter, only: [:index] 
    # do
    #   member do 
    #     post :filter
    #     get :filtered
    #   end
    # end
    resources :filtered, only: [:index,:update]
    resources :auto_search, only: :index

  end

  resources :entries
  resources :accounts do
    member do 
      get :new_child
    end
    collection do
      get :index_table
    end
  end

  namespace :books do
    # resources :importyaml, only: [:new,:create]
    # resources :open, only: :show
    resources :setup do
      get :preview
      get :create 
    end
  
    # , only: [:show, :index, :edit, :new]
  end
  resources :books do 
    member do 
      get :open 
    end
  end
  resources :users do 
    member  do
      get :profile
      patch :update_profile
    end
  end

  resources :clients do
    collection do
      post :signin
      get :home
    end
  end
  get 'home/index'
  get 'home/client'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  get 'login', to: 'clients#login', as: 'login'
  get 'logout', to: 'clients#logout', as: 'logout'

  root "home#index"
end
