Rails.application.routes.draw do
  resources :posts do
    resources :officers,only: [:new, :create]
    # resources :markups,only: [:new, :create]
    resources :reports,only: [:new, :create]
    resources :members,only: [:new, :create] do
      collection do
        get :new_applicant
      end
    end
  end

  resources :markups do
    member do
      get :display
      get :print
    end
  end

  resources :reports do
    collection do
      get :menu
      get :summary
      get :list
      get :print
      get :community_service
      get :audit_summary
      get :trustee_audit
      post :update_audit
      get :trustee_audit_pdf
    end
  end


  resources :users  do
    collection do
      post :signin
      get :district_users
      get :department_users
      get :post_users
    end
    member do
      patch :update_profile
      patch :reset_password
    end
  end

  resources :posts do
    member do
      get :visit
      get :exit_visit
    end
  end

  resources :members do
    collection do
      get :import_form
      post :import
      get :search
      post :search
      patch :search
      get :contacts
      get :new_applicant
    end
  end

  resources :officers

  get 'vdap/', to: 'vdap#home'
  get 'vdap/home'
  get 'vdap/about'
  get 'vdap/resources'

  get 'post/officers'

  get 'post/members'

  get 'post/news'
  get 'post/articles'
  get 'post/map'
  get 'post/radar'

  get 'post/links'

  get 'post/minutes'

  get 'post/about'
  get 'post/calendar'

  get 'about/about'
  get 'about/history'
  get 'about/structure'
  get 'about/access'
  get 'about/markups'
  get 'about/reports'
  get 'about/members'
  get 'about/officers'




  get 'login', to: 'users#login', as: 'login'
  get 'logout', to: 'users#logout', as: 'logout'
  get 'profile', to: 'users#profile'
  get 'article/:id' => 'markups#display'


  get 'home/index'

  get 'home/welcome'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'
  get '*path', to: 'home#redirect'

end
