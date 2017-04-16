Rails.application.routes.draw do
  root 'tournaments#index'
  resources :tournaments, only: [:index, :show, :new, :create] do
    resources :players, only: [:index, :create, :update, :destroy]
    resources :rounds, only: [:index, :show, :create, :destroy] do
      resources :pairings, only: [:create, :destroy]
      patch :repair, on: :member
    end
    patch :start, on: :member
  end
end
