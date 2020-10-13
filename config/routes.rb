Rails.application.routes.draw do
  get 'items/index'
  devise_for :users
  resources :items
  root to: "items#index"
end
