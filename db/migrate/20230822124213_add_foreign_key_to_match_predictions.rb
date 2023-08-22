class AddForeignKeyToMatchPredictions < ActiveRecord::Migration[7.0]
  def change
    add_reference :match_predictions, :match, null: false, foreign_key: true
  end
end
