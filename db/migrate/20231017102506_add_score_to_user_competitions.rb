class AddScoreToUserCompetitions < ActiveRecord::Migration[7.0]
  def change
    add_column :user_competitions, :score, :integer
  end
end
