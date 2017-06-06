Rails.application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  resources :users, except: [:destroy]
end
