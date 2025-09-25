module Oauth
  class Jwt
    def initialize(payload)
    end

    def self.generate_token(payload)
      new(payload).access_token
    end

    def access_token
      
    end

    def header
      {
        "typ": "JWT",
        "alg": "HS256"
      }
    end

    def payload
      {
        "iss": "me_dawg",
        "sub": "user_id of requester",
        "aud": "resource server or api audience",
        "exp": Time.current + 15.minutes,
        "iat": Time.current,
        "jti": SecureRandom.uuid,
        "token_type": "Bearer",
        "client_id": @client.client_id,
      }
    end

    def encode(hash)
      Base64.encode64(hash.to_json)
    end
  end
end
