module Oauth
  class Jwk < ApplicationRecord
    encrypts :key

    # ECDSA
    ALGORITHM = "ES256".freeze

    self.table_name = "jwks"

    validates :kid, presence: true, uniqueness: true
    validates :key, presence: true

    before_validation :generate_es256_keypair, on: :create
    after_create :activate_key!

    scope :active_keys, -> { where(active: true) }

    def self.active_signing_key
      active_jwk_json = active_keys.last&.key
      raise Oauth::Errors::MissingJwkError if active_jwk_json.blank?

      JWT::JWK.create_from(JSON.parse(active_jwk_json))
    end

    def generate_es256_keypair 
      jwk = JWT::JWK.new(OpenSSL::PKey::EC.generate("prime256v1"))

      assign_attributes(
        kid: jwk.kid,
        key: jwk.parameters.to_json
      )
    end


    # TODO scheduled "rotate" logic that generates a new key and then deletes any in-active key older than X time (1 month)

    def activate_key!
      self.class.active_keys.where("created_at < ?", created_at).update_all(active: false)

      update!(active: true)
    end
  end
end
