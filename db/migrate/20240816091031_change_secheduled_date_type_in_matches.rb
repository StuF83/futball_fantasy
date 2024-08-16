class ChangeSecheduledDateTypeInMatches < ActiveRecord::Migration[7.0]
  def change
    change_column :matches, :scheduled_date, :datetime
  end
end
