class AddSeasonAndLeagueToCompetitions < ActiveRecord::Migration[7.0]
  def change
    add_column :competitions, :season, :string
    add_column :competitions, :league, :string
  end
end
