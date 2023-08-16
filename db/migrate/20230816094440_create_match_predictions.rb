class CreateMatchPredictions < ActiveRecord::Migration[7.0]
  def change
    create_table :match_predictions do |t|
      t.integer :home_score_guess
      t.integer :away_score_guess
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
