class MatchPrediction < ApplicationRecord
  belongs_to :user
  belongs_to :match

  def update_result
    if self.result == 'pending' && self.match.status != nil
      if self.home_score_guess == self.match.home_score && self.away_score_guess == self.match.away_score
        self.result = 3
      elsif self.home_score_guess > self.away_score_guess && self.match.home_score > self.match.away_score ||
            self.home_score_guess < self.away_score_guess && self.match.home_score < self.match.away_score ||
            self.home_score_guess == self.away_score_guess && self.match.home_score == self.match.away_score
        self.result = 1
      else
        self.result = 0
      end
      self.save
    end
  end
end
