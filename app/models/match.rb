class Match < ApplicationRecord
  has_many :game_week_matches
  has_many :game_weeks, through: :game_week_matches
  has_many :match_predictions
end
