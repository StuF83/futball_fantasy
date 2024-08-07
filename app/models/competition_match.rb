class CompetitionMatch < ApplicationRecord
  belongs_to :competition
  belongs_to :match
end
