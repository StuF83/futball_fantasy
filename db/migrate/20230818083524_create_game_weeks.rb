class CreateGameWeeks < ActiveRecord::Migration[7.0]
  def change
    create_table :game_weeks do |t|
      t.date :start_date
      t.date :end_date
      t.integer :week_number

      t.timestamps
    end
  end
end
