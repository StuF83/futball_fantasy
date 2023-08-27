class GameWeekMatch < ApplicationRecord
  belongs_to :match
  belongs_to :game_week
end
