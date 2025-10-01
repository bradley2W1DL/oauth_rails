module Oauth
  class Jwk < ApplicationRecord
    self.table_name = jwks

    validates :key, presence: true
    validates :kid, presence: true, unique: true

    after_create :activate_key

    scope :active_keys, -> { where(active: true) }

    # override :create here instead??
    def create # does this allow first_or_create to work??
      jwk = JWT::JWK.new(OpenSSL::PKey::EC.generate("prime256v1"))

      create(
        kid: jwk.kid,
        key: jwk.parameters.to_json
      )
    end

    # TODO scheduled "rotate" logic that generates a new key and then deletes any in-active key older than X time (1 month)

    def activate_key!
      self.active_keys.where("created_at < ?", created_at).update_all(active: false)

      update!(active: true)
    end
  end
end
