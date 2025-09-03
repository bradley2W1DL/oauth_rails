class CreateAuthorizationCodes < ActiveRecord::Migration[8.0]
  def change
    create_table :authorization_codes do |t|
      t.references :client, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :user_session, null: false, foreign_key: true
      t.text :redirect_uri
      t.json :scopes
      t.string :state
      t.text :code_challenge
      t.string :code_challenge_method

      t.timestamps
    end
  end
end
