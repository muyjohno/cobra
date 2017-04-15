Rails.application.routes.draw do
  root 'tournaments#index'
  resources :tournaments, except: [:edit, :update, :destroy] do
    resources :players, only: [:create, :index, :update]
    resources :rounds, only: [:create, :index]
    patch :start, on: :member
  end
end
