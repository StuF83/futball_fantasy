class UserCompetition < ApplicationRecord
  belongs_to :user
  belongs_to :competition

  def update_user_score(prediction_result)
    score = self.score

  end
end
