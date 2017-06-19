Rails.application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  root to: 'pages#show'
  resources :users, except: [:destroy]
  resources :sessions, only: [:new, :create, :destroy]
  resources :password_resets, only: [:new, :create]
  get 'password_resets/:token', as: "edit_password_reset", to: "password_resets#edit"
end
