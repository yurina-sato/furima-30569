Rails.application.routes.draw do
  get 'items/index'
  devise_for :users
  resources :items, only: [:index, :new, :create]
  root to: "items#index"
end
