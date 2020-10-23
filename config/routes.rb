Rails.application.routes.draw do
  get 'items/index'
  devise_for :users
  resources :items do
    resources :orders, only: [:index, :create]
    resources :comments, only: [:create]
    resources :likes, only: [:create, :destroy]
    collection do
      get 'search'
    end
  end
  resources :users, only: [:show]
  root to: "items#index"
end
