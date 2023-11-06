class AddCurrentMatchDayToCompetition < ActiveRecord::Migration[7.0]
  def change
    add_column :competitions, :match_day, :integer
  end
end
