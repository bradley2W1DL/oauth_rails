class WellKnownController < ApplicationController
  # public endpoints that can be used to fetch metadata about this application server
  
  # /.well-known/oauth-authorization-server
  # OAuth 2.0 Authorization Server Metadata (RFC 8414)
  #   metadata about supported endpoints such as authorization_endpoint, token_endpoint, etc.
  #
  # @return [JSON] server metadata
  def authorization_server_metadata
    render json: {
      issuer: root_url,
      authorization_endpoint: authorize_url,
      token_endpoint: oauth_token_url,
      introspection_endpoint: introspect_url,
      revocation_endpoint: oauth_revoke_url,
      # scopes_supported: %w[read write], # TODO flesh this out OPEN OIDC + custom??
      response_types_supported: %w[code token id_token],
      grant_types_supported: %w[authorization_code client_credentials refresh_token],
      token_endpoint_auth_methods_supported: %w[client_secret_post],
      subject_types_supported: %w[public pairwise] # what is "pairwise"?
    }
  end

  # /.well-known/jwks.json
  # JSON Web Key Set (public keys for verifying JWTs)
  #   The exact URI is provided by `jwks_uri` in the discovery document
  #
  # @return [JSON] array of active JSON Web Keys
  def jwks
    render json: JsonWebKey.json_web_key_set, status: :ok
  end

  # OpenID Connect Provider Config
  def openid_configuration; end
end
