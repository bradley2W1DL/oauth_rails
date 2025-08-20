class ApplicationController < ActionController::API
  def well_known_authorization_server
    render json: {
      issuer: Rails.application.routes.url_helpers.root_url,
      authorization_endpoint: Rails.application.routes.url_helpers.authorize_url,
      token_endpoint: Rails.application.routes.url_helpers.token_url,
      introspection_endpoint: Rails.application.routes.url_helpers.introspect_url,
      revocation_endpoint: Rails.application.routes.url_helpers.revoke_url,
      scopes_supported: %w[read write], # TODO flesh this out
      response_types_supported: %w[code token id_token],
      grant_types_supported: %w[authorization_code client_credentials refresh_token],
      token_endpoint_auth_methods_supported: %w[client_secret_post],
      subject_types_supported: %w[public pairwise]
    }
  end
end
