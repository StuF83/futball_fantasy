class CreateGameWeekMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :game_week_matches do |t|
      t.references :game_week, null: false, foreign_key: true
      t.references :match, null: false, foreign_key: true

      t.timestamps
    end
  end
end
