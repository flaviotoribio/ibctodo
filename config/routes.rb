Rails.application.routes.draw do
  root to: "home#index"
  get '/home', to: redirect('/')
  devise_for :users
  resource :users

  #namespace :api do 

    resources :boards do
      resources :lists do
        resources :cards
      end
    end

  #end 

end
