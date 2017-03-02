Rails.application.routes.draw do
  root 'tournaments#index'
  resources :tournaments, except: [:edit, :update, :destroy]
end
