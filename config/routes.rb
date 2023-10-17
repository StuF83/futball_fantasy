Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'competitions#index'

  devise_for :users

  get 'matches/index', to: 'matches#index'

  get '/match_predictions/current_predictions/', to: 'match_predictions#current_predictions'
  patch '/match_predictions/current_predictions_update/', to: 'match_predictions#current_predictions_update'

  resources :competitions, only: [:index, :show, :new, :create, :update, :edit] do
    get 'leaderboard', on: :member
    resources :game_weeks, only: [:new, :create, :index]
  end

  resources :game_weeks, only: [:show, :destroy, :update]
end
