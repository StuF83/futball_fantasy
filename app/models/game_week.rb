class GameWeek < ApplicationRecord
  has_many :matches

  validates :start_date, :end_date, :week_number, presence: true



end
