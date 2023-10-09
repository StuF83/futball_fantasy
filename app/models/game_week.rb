class GameWeek < ApplicationRecord
  has_many :game_week_matches
  has_many :matches, through: :game_week_matches, dependent: :destroy
  has_many :match_predictions, through: :matches

  has_many :competition_game_weeks
  has_many :competitions, through: :competition_game_weeks

  has_many :users, through: :competitions

  validates :week_number, presence: true
  # :start_date, :end_date,
  # validates :start_date, comparison: { less_than: :end_date }
  # validate :cannot_overlap_another_game_week

  def overlap_error
    errors.add(:overlap_error, 'Game Week dates clash with an existing Game Week')
  end

  def cannot_overlap_another_game_week
    overlaps = []
    game_weeks = GameWeek.all
    game_weeks.each do |game_week|
      unless self.start_date > game_week.end_date || self.end_date < game_week.start_date
        overlaps << game_week.id
      end
    end
    overlap_error unless overlaps.empty?
  end

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
