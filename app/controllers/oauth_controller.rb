class OauthController < ApplicationController
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
    
    if params[:response_type] == "code"
      create_auth_code
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
  def consent
    # render the "consent" where user agrees to allow client to acces X scopes
  end

  private

  def create_auth_code
    # create an authorization code and store it in the database
    @auth_code = AuthorizationCode.create!(
      client: @client,
      redirect_uri: params[:redirect_uri],
      code_challenge: params[:code_challenge],
      code_challenge_method: params[:code_challenge_method],
      scope: params[:scope]&.split(" ")
    )
  end
end
