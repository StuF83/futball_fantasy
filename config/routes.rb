Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'competitions#index'

  get 'matches/index', to: 'matches#index'

  devise_for :users

  resources :competitions, only: [:index, :show, :new, :create] do
    get 'add_players', to: 'competitions#add_players'
    resources :game_weeks, only: [:new, :create, :index]
  end


  resources :game_weeks, only: [:show, :destroy] do
    resources :match_predictions, only: [:index, :new, :create]
  end

  resources :match_predictions, only: [:edit, :update] do
    collection do
      get 'current_predictions'
    end
  end
end
