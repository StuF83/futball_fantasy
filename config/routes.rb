Rails.application.routes.draw do
  root 'competitions#index'
  devise_for :users

  get '/match_predictions/current_predictions/', to: 'match_predictions#current_predictions'
  patch '/match_predictions/current_predictions_update/', to: 'match_predictions#current_predictions_update'

  #not for production
  # if Rails.env.development? || Rails.env.test?
  #   get '/match_predictions/generate_predictions', to: 'match_predictions#generate_predictions'
  # end

  resources :competitions, only: [:index, :show, :new, :create, :update, :edit] do
    resources :game_weeks, only: [:update]
    get 'leaderboard', on: :member
    post 'current_match_day', on: :member
  end

  resources :players, only: [:index, :update]
end
