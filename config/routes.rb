Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'pages#index'

  get 'matches/index', to: 'matches#index'

  get 'game_weeks/index', to: 'game_weeks#index'
  get 'game_weeks/new', to: 'game_weeks#new'
  post 'game_weeks', to: 'game_weeks#create'
  get 'game_weeks/:id', to: 'game_weeks#show', as: 'game_week'

  resources :match_predictions, only: [:index, :new, :create]

end
