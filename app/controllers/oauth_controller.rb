class OauthController < ApplicationController
  after_action :clear_code_cache, only: [:consent_decision]

  # GET /authorize
  # @param response_type [String] The type of response expected (e.g., "code" for authorization code flow).
  # @param client_id [String] The client identifier issued to the client during the registration process.
  # @param redirect_uri [String] The URI to which the response will be sent after authorization.
  # @param scope [String] The scope of the access request (e.g., "read", "write").
  # @param state [String] An opaque value used by the client to maintain state between the request and callback.
  # @param code_challenge [String] A challenge derived from the code verifier for PKCE (Proof Key for Code Exchange).
  # @param code_challenge_method [String] The method used to derive the code challenge (e.g., "S256").
  #
  # Example response:
  # If the user authorizes the request, they will be redirected to the redirect_uri with an authorization code:
  # https://yourapp.com/callback?code=authorization_code&state=random_state_string
  #
  # If the user denies the request, they will be redirected to the redirect_uri with an error:
  # https://yourapp.com/callback?error=access_denied&state=random_state_string
  #
  def authorize
    # This action would handle the OAuth authorization request.
    # It typically involves redirecting the user to a login page or displaying an authorization form.
    #   - This would need to check for an existing "session token" or JWT in the request.
    #   - if already logged in just redirect back, otherwise show login page first

    # TODO validations to make sure required params are present and valid.
    @client = Client.find_by(client_id: params[:client_id])

    # render nice_errors_path()
    Rails.logger.debug("\n#{__method__} Trace ID: #{@trace_id}\n")

    if params[:response_type] == "code"
      create_auth_code
      Rails.cache.write(code_cache_key, @auth_code.id, expires_in: 15.minutes) # long enough expiry?
    end

    redirect_to login_path
  end

  # POST /oauth/token
  def token
    # This action would handle the OAuth token request.
    # It typically involves validating the client credentials and issuing an access token.
    render json: {message: "Token endpoint"}
  end

  # POST /introspect
  def introspect
    # This action would handle the introspection of an access token.
    # It typically involves checking the validity of the token and returning its details.
    render json: {message: "Introspection endpoint"}
  end

  # POST /oauth/revoke
  def revoke
    # This action would handle the revocation of an access token.
    # It typically involves invalidating the token so it can no longer be used.
    render json: {message: "Revocation endpoint"}
  end

  # GET /consent
  def user_consent
    Rails.logger.debug("\n#{__method__} Trace ID: #{@trace_id}\n")

    @client = auth_code.client

    if current_user.consented_to?(@client, auth_code.scopes)
      redirect_to_client code: auth_code.code, state: auth_code.state
      return
    end

    # if user consents exist for a given client, skip to next step / redirect code to the redirect_uri
    # what other flows would go this way, or does this only apply to the "code grant" flow
    render :user_consent
  end

  # POST /consent_decision
  def consent_decision
    # did user accept or decline client consent on scopes?
    if cast_boolean(params[:accept])
      current_user.consents.create(client: auth_code.client, scopes: auth_code.scopes)

      redirect_to_client code: auth_code.code, state: auth_code.state
    else
      redirect_to_client error: "they're not that into you, bro", state: auth_code.state
    end
  end

  # GET /.well-known/oauth-authorization-server
  # TODO THIS ENDPOINT IS BROKEN
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

  private

  def create_auth_code
    # create an authorization code and store it in the database
    @auth_code = AuthorizationCode.create!(
      client: @client,
      redirect_uri: params[:redirect_uri],
      state: params[:state],
      code_challenge: params[:code_challenge],
      code_challenge_method: params[:code_challenge_method],
      scopes: params[:scope]&.split(" ")
    )
  end

  def redirect_to_client(**params)
    # may need to URL encode the values here (in "pair")
    query_params = params.entries.map { |pair| pair.join("=") }.join("&")

    redirect_to "#{auth_code.redirect_uri}?#{query_params}"
  end

  def auth_code
    @auth_code ||= AuthorizationCode.find_by(id: Rails.cache.fetch(code_cache_key))
  end
end
