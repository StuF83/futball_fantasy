class GameWeek < ApplicationRecord
  has_many :matches

  validates :start_date, :end_date, :week_number, presence: true
  validates :start_date, comparison: { less_than: :end_date }
  validate :cannot_overlap_another_game_week

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
end
