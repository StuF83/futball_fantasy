class AddLeagueCodeToMatches < ActiveRecord::Migration[7.0]
  def change
    add_column :matches, :league_code, :string
  end
end
