Rails.application.routes.draw do
  root to: "home#index"
  get '/home', to: redirect('/')
  devise_for :users
  resource :users
end
