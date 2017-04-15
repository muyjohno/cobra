Rails.application.routes.draw do
  root 'tournaments#index'
  resources :tournaments, except: [:edit, :update, :destroy] do
    resources :players, only: [:create, :index, :update]
    resources :rounds, only: [:create, :index, :show, :destroy] do
      resources :pairings, only: [:create, :destroy]
      patch :repair, on: :member
    end
    patch :start, on: :member
  end
end
