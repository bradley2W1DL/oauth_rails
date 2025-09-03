class CreateRefreshTokens < ActiveRecord::Migration[8.0]
  def change
    create_table :refresh_tokens do |t|
      t.text :token
      t.references :client, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :user_session, null: false, foreign_key: true
      t.json :scopes
      t.datetime :issued_at
      t.datetime :expires_at
      t.boolean :revoked, default: false
      t.integer :parent_token

      t.timestamps
    end
  end
end
