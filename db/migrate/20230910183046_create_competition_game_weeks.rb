class CreateCompetitionGameWeeks < ActiveRecord::Migration[7.0]
  def change
    create_table :competition_game_weeks do |t|
      t.references :competition, null: false, foreign_key: true
      t.references :game_week, null: false, foreign_key: true

      t.timestamps
    end
  end
end
