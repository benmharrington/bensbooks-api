class AddUpvotesAndDownvotesToSynopses < ActiveRecord::Migration[8.0]
  def change
    add_check_constraint :synopses, "user_id IS NOT NULL", name: "synopses_user_id_null", validate: false
    add_column :synopses, :upvotes, :integer, default: 0, null: false # Add upvotes column
    add_column :synopses, :downvotes, :integer, default: 0, null: false # Add downvotes column
  end
end
