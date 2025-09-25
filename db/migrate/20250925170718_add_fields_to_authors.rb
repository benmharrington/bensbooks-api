class AddFieldsToAuthors < ActiveRecord::Migration[8.0]
  def change
    add_column :authors, :full_name, :string, null: false, default: ""
    add_column :authors, :birthdate, :date
    add_column :authors, :deathdate, :date
    add_column :authors, :birthplace, :string, null: false, default: ""
    add_column :authors, :link, :string, null: false, default: ""
  end
end
