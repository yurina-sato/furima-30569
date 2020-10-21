Rails.application.routes.draw do
  get 'items/index'
  devise_for :users
  resources :items do
    resources :orders, only: [:index, :create]
    resources :comments, only: [:create]
    collection do
      get 'search'
    end
  end
  root to: "items#index"
end
