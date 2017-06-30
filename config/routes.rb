Rails.application.routes.draw do
  root 'tournaments#index'
  resources :tournaments, only: [:index, :create, :edit, :update, :destroy] do
    resources :players, only: [:index, :create, :update, :destroy] do
      get :standings, on: :collection
      get :meeting, on: :collection
      patch :drop, on: :member
      patch :reinstate, on: :member
    end
    resources :rounds, only: [:index, :show, :create, :destroy] do
      resources :pairings, only: [:index, :create, :destroy] do
        post :report, on: :member
      end
      patch :repair, on: :member
    end
    post :upload_to_abr, on: :member
    get :save_json, on: :member
    post :cut, on: :member
  end
end
