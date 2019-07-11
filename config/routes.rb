Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'jwt/auth'
      post 'jwt/refresh'
    end
  end

  resources :users do
    resources :allowed_apps, only: [:index, :create, :show, :edit, :update, :destroy] do
    end
    member do
      get 'password'
      post 'password', to: 'users#update_password', as: 'update_password'
      get 'reset_user_key'
    end
  end
  resources :apps do
    member do
      get 'reset_app_key'
      get 'reset_jwt_secret'
    end
  end
  devise_for :admins, controllers: { registrations: 'registrations', sessions: 'sessions'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'apps#index'
end
