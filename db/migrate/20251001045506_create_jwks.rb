class CreateJwks < ActiveRecord::Migration[8.0]
  def change
    create_table :jwks do |t|
      t.string :kid, null: false, index: { unique: true }
      t.text :key, null: false
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
