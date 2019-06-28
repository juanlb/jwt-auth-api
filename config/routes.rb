Rails.application.routes.draw do
  resources :users do
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
  devise_for :admins
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'apps#index'
end
