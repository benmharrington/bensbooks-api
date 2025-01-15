class ChangeBookNameToTitle < ActiveRecord::Migration[8.0]
  def change
    rename_column :books, :name, :title
  end
end
