Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'pages#index'

  get 'matches/index', to: 'matches#index'

  resources :game_weeks, only: [:index, :new, :create, :show, :destroy] do
    resources :match_predictions, only: [:new, :create, :show]
  end

  resources :match_predictions, only: [:index]

end
