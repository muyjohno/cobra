Rails.application.routes.draw do
  root 'tournaments#index'
  resources :tournaments, only: [:index, :new, :create] do
    resources :players, only: [:index, :create, :update, :destroy]
    resources :rounds, only: [:index, :show, :create, :destroy] do
      resources :pairings, only: [:create, :destroy] do
        post :report, on: :member
      end
      patch :repair, on: :member
    end
  end
end
