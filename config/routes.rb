Antarcticle::Application.routes.draw do

  resources :sessions, only: [:new, :create, :destroy]
  #resources :users, only: [:show]
  resources :articles

  root :to => 'articles#index'

  match '/signin', to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

  match '/users/:username', to: 'users#show', as: :user, :username => /[^\/]*/

  get '/tags/:tag', to: 'articles#index', as: :tag, :tag => /[^\/]*/

end
