require "jwt"

module Oauth
  class Jwt
    def initialize(payload)
    end

    def self.generate_token(payload)
      new(payload).access_token
    end

    # @return [String] JWT access token
    def access_token
      # base64 encode header + "." + base64 encode payload; Signed w/ signature appended
    end

    def signing_key
      Jwk.active_signing_key
    end

    def header
      {
        typ: "JWT",
        alg: Oauth::Jwk::ALGORITHM,
        kid: signing_key.kid # key_id: thumbprint of signing key (can be pulled from Oauth::Jwk instance)
      }
    end

    def payload
      {
        iss: "me_dawg",
        sub: "user_id of requester",
        aud: "resource server or api audience",
        exp: Time.current + 15.minutes,
        iat: Time.current,
        jti: SecureRandom.uuid,
        token_type: "Bearer",
        client_id: @client.client_id
      }
    end

    def encode(hash)
      Base64.encode64(hash.to_json)
    end
  end
end
