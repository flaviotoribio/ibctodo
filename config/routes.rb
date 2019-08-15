Rails.application.routes.draw do
  root to: "home#index"
  get '/home', to: redirect('/')
  devise_for :users
  resource :users

  resources :boards do
    resources :lists do
      resources :cards
    end
  end

  match "/board/:id" => "home#board", via: :get, as: "home_board"

end
