Rails.application.routes.draw do
  root 'competitions#index'
  devise_for :users

  get '/match_predictions/current_predictions/', to: 'match_predictions#current_predictions'
  patch '/match_predictions/current_predictions_update/', to: 'match_predictions#current_predictions_update'

  #not for production
  get '/match_predictions/generate_predictions', to: 'match_predictions#generate_predictions'

  resources :competitions, only: [:index, :show, :new, :create, :update, :edit] do
    member do
      get 'leaderboard'
      post 'current_match_day'
      get 'add_users'
      post 'update_users'
      # resources :game_weeks, only: [:update]
    end
  end
end
