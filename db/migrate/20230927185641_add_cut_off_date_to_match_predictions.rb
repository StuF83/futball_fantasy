class AddCutOffDateToMatchPredictions < ActiveRecord::Migration[7.0]
  def change
    add_column :match_predictions, :cut_off_date, :date
  end
end
