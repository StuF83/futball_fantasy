class AddResultToMatchPredictions < ActiveRecord::Migration[7.0]
  def change
    add_column :match_predictions, :result, :string, default: 'pending'
  end
end
