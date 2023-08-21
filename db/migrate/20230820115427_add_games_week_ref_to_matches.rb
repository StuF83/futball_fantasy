class AddGamesWeekRefToMatches < ActiveRecord::Migration[7.0]
  def change
    add_reference :matches, :game_week, null: true, foreign_key: true
  end
end
