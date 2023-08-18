class GameWeek < ApplicationRecord
  validates :start_date, :end_date, :week_number, presence: true
end
