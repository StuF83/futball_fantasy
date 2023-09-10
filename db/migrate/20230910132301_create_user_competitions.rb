class CreateUserCompetitions < ActiveRecord::Migration[7.0]
  def change
    create_table :user_competitions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :competition, null: false, foreign_key: true

      t.timestamps
    end
  end
end
