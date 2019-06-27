Rails.application.routes.draw do
  resources :users do
    member do
      get 'password'
      post 'password', to: 'users#update_password', as: 'update_password'
    end
  end
  resources :apps
  devise_for :admins
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'apps#index'
end
