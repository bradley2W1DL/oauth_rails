class CreateJsonWebKeys < ActiveRecord::Migration[8.0]
  def change
    create_table :json_web_keys do |t|
      t.boolean :active, default: false
      t.string :kid, index: {unique: true}
      t.json :public_jwk, comment: "JWK JSON that is safe to share publicly"
      t.json :private_jwk, comment: "JWK JSON that is NOT to be shared. Contains private key value ('d')"

      t.timestamps
    end
  end
end
