Rails.application.routes.draw do
  resources :pdfs
  resources :forms do
    collection do
      get :bartender
      get :cash_report
    end
  end
  get 'test/test'
  patch 'test/fire'
  patch 'test/clear'
  patch 'test/unclear'
  get 'test/link'
  post 'test/link'

  # get 'trustee_audits/index'
  # get 'trustee_audits/show'
  # get 'trustee_audits/new'
  # get 'trustee_audits/create'
  # get 'trustee_audits/edit'
  # get 'trustee_audits/update'
  # get 'trustee_audits/destroy'
  # get 'trustee_audits/pdf'
  resources :posts do
    resources :officers,only: [:new, :create]
    # resources :markups,only: [:new, :create]
    resources :reports,only: [:new, :create]
    resources :members,only: [:new, :create] do
      collection do
        get :new_applicant
      end
    end
    member do
      get :edit_calendar
      post :update_calendar
    end
  end

  resources :markups do
    member do
      get :display
      get :print
      get :plain
    end
  end

  resources :reports do
    collection do
      get :menu
      get :summary
      get :list
      get :list_all

      get :print
      get :community_service
      get :audit_summary
      get :cs_report
      get :quarter
      # get :trustee_audit
      # post :update_audit
      # get :trustee_audit_pdf
    end
  end

  resources :trustee_audits do
    collection do
      get :get_audit
      get :pdf
      post :update_audit
    end
    member do
      get :pdf
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
    member do
      get :test_email
    end
    collection do
      get :import_form
      post :import
      get :search
      post :search
      patch :search
      get :contacts
      get :new_applicant
      # below were original mass email/mail stuff
      get :test_mail
      # get :send_mailer
      get :get_mailable
    end
  end

  resources :officers do
    collection do
      get :cmdr
    end
  end

  get 'vdap/', to: 'vdap#home'
  get '/page/:id', to: 'vdap#resources'
  get 'vdap/home'
  get 'vdap/about'
  get 'vdap/resources'

  get 'post/officers'

  get 'post/members'
  get 'post/edit'
  get 'post/news'
  get 'post/articles'
  get 'post/map'
  get 'post/radar'

  get 'post/links'

  get 'post/minutes'

  get 'post/about'
  get 'post/calendar'
  get 'post/month_calendar'

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
