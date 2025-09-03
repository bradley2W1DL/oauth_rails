class AddCodeToAuthorizationCode < ActiveRecord::Migration[8.0]
  def change
    add_column :authorization_codes, :code, :string, null: false, default: "000"
  end
end
