class CreateUserConsents < ActiveRecord::Migration[8.0]
  def change
    create_table :user_consents do |t|
      t.references :user, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.json :scopes

      t.timestamps
    end
  end
end
