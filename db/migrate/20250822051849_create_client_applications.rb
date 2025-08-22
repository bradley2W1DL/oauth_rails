class CreateClientApplications < ActiveRecord::Migration[8.0]
  def change
    create_table :client_applications do |t|
      t.string :name
      t.json :redirect_uris, default: []
      t.string :client_id
      t.string :client_secret_digest
      t.integer :application_type

      t.timestamps
    end
  end
end
