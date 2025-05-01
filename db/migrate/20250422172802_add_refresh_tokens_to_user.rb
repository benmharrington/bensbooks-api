class AddRefreshTokensToUser < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    add_column :users, :refresh_token, :string
    add_column :users, :refresh_token_expires_at, :datetime
    add_index :users, :refresh_token, unique: true, algorithm: :concurrently
  end
end
