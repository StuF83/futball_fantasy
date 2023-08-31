Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'pages#index'

  get 'matches/index', to: 'matches#index'

  resources :game_weeks, only: [:index, :new, :create, :show, :destroy] do
    resources :match_predictions, only: [:new, :create]
  end


  # get 'game_weeks', to: 'game_weeks#index', as: 'game_weeks'
  # get 'game_weeks/new', to: 'game_weeks#new'
  # post 'game_weeks', to: 'game_weeks#create'
  # get 'game_weeks/:id', to: 'game_weeks#show', as: 'game_week'
  # delete 'game_weeks/:id', to: 'game_weeks#destroy', as: 'destroy_game_week'


  resources :match_predictions, only: [:index]

end
