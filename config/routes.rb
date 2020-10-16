Rails.application.routes.draw do
  get 'items/index'
  devise_for :users
  resources :items do
    resources :orders, only: [:index, :create]
  end
  root to: "items#index"
end
