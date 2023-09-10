class Competition < ApplicationRecord
  has_many :user_competitions
  has_many :users, through: :user_competitions

  has_many :competition_game_weeks
  has_many :game_weeks, through: :competition_game_weeks
end
