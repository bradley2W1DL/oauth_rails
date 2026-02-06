class JsonWebKey < ApplicationRecord
  encrypts :private_jwk

  ALGORITHM = "EdDSA".freeze # Edwards-curve Digital Signature Algorithm

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

  def self.current
    active.order(:created_at).last
  end
end

# == Schema Information
#
# Table name: json_web_keys
#
#  id          :integer          not null, primary key
#  active      :boolean          default(FALSE)
#  kid         :string
#  private_jwk :json
#  public_jwk  :json
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_json_web_keys_on_kid  (kid) UNIQUE
#
