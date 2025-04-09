class AddSynopsisVotesTable < ActiveRecord::Migration[8.0]
  def change
    create_table :synopsis_votes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :synopsis, null: false, foreign_key: true
      t.integer :vote, null: false # -1 for downvote, 1 for upvote

      t.timestamps

      # Add a composite index to ensure a user can vote only once per synopsis
      t.index [ :user_id, :synopsis_id ], unique: true
    end
  end
end
