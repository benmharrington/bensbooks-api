class CreateRatingsTable < ActiveRecord::Migration[8.0]
  def change
    create_table :ratings do |t|
      t.references :user, foreign_key: true
      t.references :book, foreign_key: true
      t.integer :score, null: false
      t.text :review
      t.timestamps

      t.index [ :user_id, :book_id ], unique: true
    end
  end
end
