class Match < ApplicationRecord
  has_many :game_week_matches
  has_many :game_weeks, through: :game_week_matches
  has_many :match_predictions

  accepts_nested_attributes_for :match_predictions

  def match_predictions_attributes=(match_predictions_attributes)
  end
end
