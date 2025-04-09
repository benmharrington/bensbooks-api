class ValidateAddUpvotesAndDownvotesToSynopses < ActiveRecord::Migration[8.0]
  def up
    validate_check_constraint :synopses, name: "synopses_user_id_null"
    change_column_null :synopses, :user_id, false
    remove_check_constraint :synopses, name: "synopses_user_id_null"
  end

  def down
    add_check_constraint :synopses, "user_id IS NOT NULL", name: "synopses_user_id_null", validate: false
    change_column_null :synopses, :user_id, true
  end
end
