# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users,
             controllers: { omniauth_callbacks: "users/omniauth_callbacks" },
             skip: [:sessions]
  as :user do
    delete "users/logout", to: "devise/sessions#destroy", as: :destroy_user_session
  end

  get "service_autocomplete", to: "services#autocomplete", as: :service_autocomplete


  resources :services, only: [:index, :show] do
    scope module: :services do
      resources :offers, only: :index
      resource :offers, only: :update
      resource :configuration, only: [:show, :update]
      resource :summary, only: [:show, :create]
      resource :cancel, only: :destroy
      resource :questions, only: [:create]
      resources :opinions, only: :index
    end
  end
  get "services/c/:category_id" => "services#index", as: :category_services

  resources :categories, only: :show

  resources :projects do
    scope module: :projects do
      resources :about, only: :index
      resources :services, only: [:show, :index]
      resource :chat, only: :show
    end
  end
  resources :project_items, only: :show do
    scope module: :project_items do
      resources :questions, only: [:index, :create]
      resources :service_opinions, only: [:new, :create]
    end
  end

  resource :profile, only: :show

  resource :backoffice, only: :show
  namespace :backoffice do
    resources :services do
      scope module: :services do
        resources :offers
        resources :offers do
          scope module: :offers do
            resource :publish, only: :create
            resource :draft, only: :create
          end
        end

        resource :publish, only: :create
        resource :draft, only: :create
      end
    end
    get "service_autocomplete", to: "services#autocomplete", as: :service_autocomplete
    get "services/c/:category_id" => "services#index", as: :category_services
    resources :research_areas
    resources :categories
    resources :providers
    resources :platforms
  end

  namespace :api do
    namespace :webhooks do
      post "/jira" => "jiras#create", as: :jira
    end
  end

  if Rails.env.development?
    get "playground/:file" => "playground#show",
        constraints: { file: %r{[^/\.]+} }
  end

  resource :admin, only: :show
  namespace :admin do
    resources :jobs, only: :index
  end
  # Sidekiq monitoring
  authenticate :user, ->(u) { u.admin? } do
    require "sidekiq/web"
    mount Sidekiq::Web => "/admin/sidekiq"
  end

  get "errors/not_found"
  get "errors/unprocessable"
  get "errors/internal_server_error"
  match "about", to: "pages#about", via: "get", as: :about

  if Rails.env.production?
    match "/404", to: "errors#not_found", via: :all
    match "/422", to: "errors#unprocessable", via: :all
    match "/500", to: "errors#internal_server_error", via: :all
  end

  root "home#index"
end
