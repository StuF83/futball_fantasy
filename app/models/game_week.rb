class GameWeek < ApplicationRecord
  has_many :game_week_matches
  has_many :matches, through: :game_week_matches, dependent: :destroy
  has_many :match_predictions, through: :matches

  has_many :competition_game_weeks
  has_many :competitions, through: :competition_game_weeks

  has_many :users, through: :competitions

  validates :week_number, presence: true

  def weekly_score(player)
    score = 0
    self.match_predictions.where(user: player).each do |match_prediction|
      unless match_prediction.result == 'pending'
        score += match_prediction.result.to_i
      end
    end
    score
  end
end
