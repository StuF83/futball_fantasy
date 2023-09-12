class MatchPrediction < ApplicationRecord
  belongs_to :user
  belongs_to :match

  def update_result
    if self.result == 'pending'
      if self.home_score_guess == self.match.home_score && self.away_score_guess == self.match.away_score
        self.result = 'exact score'
      elsif self.home_score_guess > self.away_score_guess && self.match.home_score > self.match.away_score ||
            self.home_score_guess < self.away_score_guess && self.match.home_score < self.match.away_score ||
            self.home_score_guess == self.away_score_guess && self.match.home_score == self.match.away_score
        self.result = 'correct'
      else
        self.result = 'incorrect'
      end
    end
  end

end
