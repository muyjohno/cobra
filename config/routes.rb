Rails.application.routes.draw do
  root 'tournaments#index'
  resources :tournaments, except: [:edit, :update, :destroy] do
    resources :players, only: :create
    patch :start, on: :member
    resources :rounds, only: :create
  end
end
