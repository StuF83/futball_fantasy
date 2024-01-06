Rails.application.routes.draw do
  root 'competitions#index'
  devise_for :users

  get 'matches/index', to: 'matches#index'

  get '/match_predictions/current_predictions/', to: 'match_predictions#current_predictions'
  patch '/match_predictions/current_predictions_update/', to: 'match_predictions#current_predictions_update'

  #not for production
  get '/match_predictions/generate_predictions', to: 'match_predictions#generate_predictions'

  resources :competitions, only: [:index, :show, :new, :create, :update, :edit] do
    get 'leaderboard', on: :member
    post 'current_match_day', on: :member
    resources :game_weeks, only: [:new, :create, :index, :update]
  end

  resources :game_weeks, only: [:show, :destroy ]
end
