Rails.application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  root to: 'pages#show'
  get 'instructions', as: "instructions", to: "pages#instructions"
  resources :users, except: [:destroy]
  resources :sessions, only: [:new, :create, :destroy]
  resources :password_resets, only: [:new, :create]
  get 'password_resets/:token', as: "edit_password_reset", to: "password_resets#edit"
  patch 'password_resets', as: "update_password_reset", to: "password_resets#update"
  post 'messages/reply', to: "messages#reply"
  get 'sitemap.xml', to: 'sitemaps#index', defaults: {format: 'xml'}
end
