class AddRatingColumnToSynopses < ActiveRecord::Migration[8.0]
  def change
    add_column :synopses, :rating, :integer, null: false, default: 0
  end
end
