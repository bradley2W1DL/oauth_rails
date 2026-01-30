class JsonWebKey < ApplicationRecord
  encrypts :private_jwk

  scope :active, -> { where(active: true) }

  validates :kid, presence: true, uniqueness: true
  validates :private_jwk, presence: true

  # Standard JWKS array that contains any "active" keys
  #
  # @return [JSON] keys -> Array<JWK>
  def self.json_web_key_set
    keys = active.pluck(:public_jwk)

    {keys:}.as_json
  end

  # Generate a new JWK and persist to database
  #
  # @return [JsonWebKey] newly created key
  def self.generate
    private_key = Ed25519::SigningKey.generate
    jwk = JWT::JWK.new(private_key, {use: "sig"})

    create!(
      kid: jwk.parameters[:kid],
      public_jwk: jwk.export,
      private_jwk: jwk.export(include_private: true),
      active: true
    )
  end
end
