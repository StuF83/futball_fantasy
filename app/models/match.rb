class Match < ApplicationRecord
  belongs_to :game_week, optional: true
  has_many :match_predictions
end
