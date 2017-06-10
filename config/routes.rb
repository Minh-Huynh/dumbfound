Rails.application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  root to: 'pages#show'
  resources :users, except: [:destroy]
  resources :sessions, only: [:new, :create, :destroy]
end
