Antarcticle::Application.routes.draw do

  resources :sessions, only: [:new, :create, :destroy]
  resources :articles do
    resources :comments, only: [:create, :update, :edit, :destroy]
  end

  root :to => 'articles#index'

  match '/signin', to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

  match '/users/:username', to: 'users#show', as: :user, :username => /[^\/]*/

  match '/tags/:tags', to: 'tags#index', as: :tag, :tags => /.*/
  get '/tags_filter', to: 'tags#filter', as: :tags_filter
  match '/tags', to: redirect("/")
end
