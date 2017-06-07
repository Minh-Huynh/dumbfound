Rails.application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  resources :users, except: [:destroy]
  resources :sessions, only: [:create, :destroy]
end
