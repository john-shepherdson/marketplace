# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users,
             controllers: { omniauth_callbacks: "users/omniauth_callbacks" },
             skip: [:sessions]
  as :user do
    delete "users/logout", to: "devise/sessions#destroy", as: :destroy_user_session
  end

  resources :services, only: [:index, :show]
  resources :categories, only: :show
  resources :orders, only: [:index, :show, :create] do
    scope module: :orders do
      resources :questions, only: [:index, :create]
    end
  end

  resource :profile, only: [:show] do
    scope module: :profiles do
      resources :affiliations
    end
  end

  if Rails.env.development?
    get "playground/:file" => "playground#show",
        constraints: { file: %r{[^/\.]+} }
  end

  root "home#index"
end
