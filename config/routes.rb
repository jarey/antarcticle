Antarcticle::Application.routes.draw do

  resources :sessions, only: [:new, :create, :destroy]
  resources :articles

  root :to => 'articles#index'

  match '/signin', to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

  match '/users/:username', to: 'users#show', as: :user, :username => /[^\/]*/

  match '/tags/:tags', to: 'tags#index', as: :tag, :tags => /[^\/]*/

end
