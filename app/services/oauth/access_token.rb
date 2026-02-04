module Oauth
  class AccessToken
    attr_reader :client_id, :subject, :token_identifier, :scopes

    include Rails.application.routes.url_helpers

    TOKEN_EXPIRATION = 3600 # 1 hour in seconds

    def initialize(client_id:, subject:, scopes: [])
      @client_id = client_id
      # @grant_type = grant_type
      @subject = subject
      @scopes = scopes
      @token_identifier = SecureRandom.uuid # this should be persisted somewhere for revocation purposes
      @jwk = JsonWebKey.current
    end

    # Generate JWT and sign it with current active JWK
    #
    # @return [JSON] jwt
    def mint_and_sign!
      token = JWT::Token.new(payload: claims, header: base_header)
      token.sign!(key: current_active_jwk, algorithm: JsonWebKey::ALGORITHM)

      token.jwt
    end

    def base_header
      # type = Access token JWT
      #
      {typ: "at+jwt", kid: @jwk.kid}
    end

    # Claims
    # • iss, alg, kid → find and verify signer via jwks_uri / metadata.
    # • aud → ensure token is intended for this resource; reject otherwise.
    # • exp, iat → time validity and clock-skew handling.
    # • sub → identify principal for authorization decisions, local session lookup, logging.
    # • client_id → differentiate client vs user-based access and apply client policies.
    # • jti → revocation, one-time-use, and audit.
    # • scope / roles / groups / entitlements → fine-grained authorization without introspection;
    #   resource server still combines claims with contextual checks.
    def claims
      {
        iss: issuer,
        exp: expiration,
        aud: audience,
        sub: subject_id,
        client_id:,
        iat: issued_at,
        jti: token_identifier,
        scope: scopes.join(" ")
      }
    end

    # "iss" is the issuer identifier — typically an HTTPS URI (scheme + host, optionally a stable path)
    # that uniquely identifies the authorization server and MUST exactly match the "issuer" value published
    # in the AS metadata (RFC8414/OpenID discovery).
    def issuer
      root_url # tbd if this is the correct value here
    end

    # @return [Array<URI> | URI] resource(s) where this token will be used
    def audience
      # TODO this will require some extra work to add "resource" to the /authorize AND /token requests
      # returns a statice URI (or URN) of the resource server that will accept this token (specified by the client requesting the token)
      "htts://api.example.com"
    end

    # @return [String] internal identifier of intended subject
    def subject_id
      case subject.class.name
      when "User"
        "user:#{subject.id}"
      when "Client"
        "client:#{subject.id}"
      else
        raise "#{self.class}#subject_id - Invalid subject type: #{subject.class}"
      end
    end

    # Time when this token expires
    #
    # @return [Int] integer seconds for token expiry
    def expiration
      TOKEN_EXPIRATION.seconds.from_now.utc.to_i
    end

    # Time that access token was minted (UTC)
    #
    # @return [Int] integer seconds since epoch
    def issued_at
      Time.current.utc.to_i
    end

    private

    def current_active_jwk
      JWT::JWK.import(@jwk.private_jwk)
    end
  end
end
