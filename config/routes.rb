Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'competitions#index'

  get 'matches/index', to: 'matches#index'

  devise_for :users

  resources :competitions, only: [:index, :show]

  resources :game_weeks do
    resources :match_predictions, only: [:index, :new, :create]
  end

  resources :match_predictions, only: [:edit, :update]
end
