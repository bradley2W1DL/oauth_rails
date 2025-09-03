class RemoveNullConstraintFromAuthorizationCodeColumns < ActiveRecord::Migration[8.0]
  def change
    change_column :authorization_codes, :user_id, :integer, null: true
    change_column :authorization_codes, :user_session_id, :integer, null: true
  end
end
