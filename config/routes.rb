Rails.application.routes.draw do
  root 'home#home'

  get :login, to: 'oauth#auth'
  get :logout, to: 'oauth#logout'

  namespace :oauth do
    get :callback
  end

  resources :tournaments, only: [:show, :index, :create, :edit, :update, :destroy] do
    resources :players, only: [:index, :create, :update, :destroy] do
      get :standings, on: :collection
      get :meeting, on: :collection
      patch :drop, on: :member
      patch :reinstate, on: :member
    end
    resources :rounds, only: [:index, :show, :create, :destroy] do
      resources :pairings, only: [:index, :create, :destroy] do
        post :report, on: :member
        get :match_slips, on: :collection
      end
      patch :repair, on: :member
      patch :complete, on: :member
    end
    post :upload_to_abr, on: :member
    get :save_json, on: :member
    post :cut, on: :member
    get :qr, on: :member
    get :shortlink, on: :collection
    get :not_found, on: :collection
  end

  get ':slug', to: 'tournaments#shortlink'
end
