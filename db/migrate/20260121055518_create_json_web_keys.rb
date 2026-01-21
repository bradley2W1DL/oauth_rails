class CreateJsonWebKeys < ActiveRecord::Migration[8.0]
  def change
    create_table :json_web_keys do |t|
      t.boolean :active, default: false
      t.string :kid
      t.string :full_key
      t.string :pub_key

      t.timestamps
    end
  end
end
