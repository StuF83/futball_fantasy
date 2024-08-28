class AddCompetitionToMatchPredictions < ActiveRecord::Migration[7.0]
  def change
    add_reference :match_predictions, :competition, foreign_key: true

  end
end
