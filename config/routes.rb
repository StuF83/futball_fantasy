Rails.application.routes.draw do
  # devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'pages#index'

  get 'matches/index', to: 'matches#index'
  devise_for :users
    resources :users do
      resources :match_predictions, only: [:show]
    end

  resources :game_weeks do
    member do
      match 'submit_predictions', to: 'match_predictions#submit_game_week_predictions', via: [:get, :post]
    end
    resources :match_predictions, only: [:new, :edit]
  end
    # resources :match_predictions, only: [:new, :create, :show, :update]
  # resources :match_predictions, only: [:index]
end
