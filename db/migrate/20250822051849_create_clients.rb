class CreateClients < ActiveRecord::Migration[8.0]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :client_id
      t.string :client_secret
      t.json :redirect_uris, default: []
      t.integer :application_type

      t.timestamps
    end
  end
end
