Rails.application.routes.draw do
  resources :tournaments, only: [:show]
end
