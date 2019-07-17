Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth/login'
      post 'auth/refresh'
      post 'auth/valid'
      get 'auth/public_key'
    end
  end

  resources :allowed_apps, only: [:show, :edit, :update, :destroy]

  resources :users do
    get 'allowed_apps', to: 'allowed_apps#index_user'
    resources :allowed_apps, only: [:create]
    member do
      get 'password'
      post 'password', to: 'users#update_password', as: 'update_password'
      get 'reset_user_key'
    end
  end

  resources :apps do
    get 'allowed_apps', to: 'allowed_apps#index_app'
    member do
      get 'reset_app_key'
      get 'reset_rsa_key_pair'
    end
  end

  devise_for :admins, controllers: { registrations: 'registrations', sessions: 'sessions'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'apps#index'
end
