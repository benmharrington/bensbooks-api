class AddSynopsesTable < ActiveRecord::Migration[8.0]
  def change
    create_table :synopses do |t|
      t.text :content
      t.references :book, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
