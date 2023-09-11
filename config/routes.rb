Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'pages#index'

  get 'matches/index', to: 'matches#index'

  resources :competitions, only: [:index, :show]

  resources :game_weeks do
    resources :match_predictions, only: [:index, :new, :create]
  end

  resources :match_predictions, only: [:edit, :update]
end
