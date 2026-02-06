class OauthController < ApplicationController
  after_action :clear_code_cache, only: [:consent_decision]

  # handle exceptions via an included module
  rescue_from Oauth::Errors::ClientNotFound, with: :client_not_found
  rescue_from Oauth::Errors::InvalidRequest, with: :invalid_request

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
    # this should include requiring a :code_challenge param

    @client = Client.find_by(client_id: params[:client_id])

    # render nice_errors_path()
    # Rails.logger.debug("\n#{__method__} Trace ID: #{@trace_id}\n")

    if params[:response_type] == "code"
      create_auth_code
      Rails.cache.write(code_cache_key, @auth_code.id, expires_in: 15.minutes) # long enough expiry?
    end

    redirect_to login_path
  end

  # POST /oauth/token
  # @param grant_type [String] oneof "authorization_code", "client_credentials", "refresh_token"
  # @param code [String] The auth code received from the authorization server.
  # @param client_id [String] client_id issued to the client app during the registration process.
  # @param client_secret [String] <optional> client_secret issued to the client during the registration process (if applicable -- only for private clients)
  # @param code_verifier [String] The original code verifier used to generate the code challenge for PKCE.
  # @param redirect_uri [String] The redirect URI used in the initial authorization request.
  #
  # @return [JSON] A JSON response containing the access token and related information. (JWT??)
  def token
    case token_params["grant_type"]
    when "authorization_code"
      oauth_klass = Oauth::AuthorizationCodeFlow
    when "client_credentials"
      oauth_klass = Oauth::ClientCredentialsFlow
    when "refresh_token"
      raise Error.new "not implemented"
      # oauth_klass = Oauth::RefreshTokenFlow
    else
      raise "Grant Type `#{token_params.grant_type}` not supported"
    end

    access_token = oauth_klass.new(**token_params.to_h.symbolize_keys).generate_access_token!

    render json: {access_token:, token_type: "Bearer", expires_in: "sometime"}, status: :created
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

  def fetch_auth_code
    @auth_code = AuthorizationCode.find_by!(client: @client, code: token_params[:code])
  end

  def redirect_to_client(**params)
    # may need to URL encode the values here (in "pair")
    query_params = params.entries.map { |pair| pair.join("=") }.join("&")

    redirect_to "#{auth_code.redirect_uri}?#{query_params}"
  end

  def auth_code
    @auth_code ||= AuthorizationCode.find_by(id: Rails.cache.fetch(code_cache_key))
  end

  def token_params
    params.permit(
      :grant_type,
      :code,
      :client_id,
      :client_secret,
      :code_verifier,
      :redirect_uri
    )
  end

  def invalid_request(error)
    render json: {error: "invalid_request", message: error.message}, status: :unprocessable_entity
  end

  def client_not_found
    render json: {error: "oauth client not found. Has it been registered?"}, status: :not_found
  end
end
