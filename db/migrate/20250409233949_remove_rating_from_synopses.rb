class RemoveRatingFromSynopses < ActiveRecord::Migration[8.0]
  def change
    safety_assured { remove_column :synopses, :rating, :integer }
  end
end
