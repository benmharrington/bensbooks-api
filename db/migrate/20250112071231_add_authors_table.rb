class AddAuthorsTable < ActiveRecord::Migration[8.0]
  def change
    create_table :authors do |t|
      t.string :name
      t.string :bio
      t.timestamps
    end

    # add belongs_to :author to Book model
    add_reference :books, :author, foreign_key: true
  end
end
