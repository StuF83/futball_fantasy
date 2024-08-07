class CreateCompetitionMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :competition_matches do |t|
      t.references :competition, null: false, foreign_key: true
      t.references :match, null: false, foreign_key: true

      t.timestamps
    end

    add_index :competition_matches, [:competition_id, :match_id], unique: true
  end
end
