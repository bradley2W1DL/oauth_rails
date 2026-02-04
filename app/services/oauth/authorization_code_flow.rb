module Oauth
  class AuthorizationCodeFlow < OauthBase
    attr_reader :redirect_uri, :code, :code_verifier, :client, :grant_type

    def initialize(client_id:, redirect_uri:, grant_type:, code: nil, code_verifier: nil, client_secret: nil)
      if grant_type != "authorization_code"
        # this request should be handled by some other service
        raise "Invalid grant_type: #{grant_type} passed to Oauth::AuthorizationCodeFlow service"
      end

      if client_secret.nil? && code_verifier.nil?
        # public clients MUST use code_verifier for Proof Key for Code Exchange (PKCE)
        raise Errors::InvalidRequest.new(message: "code_verifier is required for PKCE auth code requests")
      end

      @code = code
      @code_verifier = code_verifier
      @grant_type = grant_type
      # if client_secret is present ensure it's a part of this query. If not, PKCE must be enforced
      client_params = {client_id:, client_secret:}.compact
      @client = Client.find_by!(client_params)
    end

    def generate_access_token!
      verify_redirect_uri!
      verify_code!

      Oauth::AccessToken.new(client_id: client.client_id, subject: @auth_code.user, scopes: @auth_code.scopes).mint_and_sign!
    ensure
      # ensure auth code is destroyed after it's verified (one-time-use only)
      @auth_code&.destroy
    end

    private

    # Check that the redirect URI on the incoming request matches the URI registerd on the AuthCode initial request
    # I mismatch here indicates a potential interception attack or similar shenanigans
    #   - this is extra verification that SHOULD happen but doesn't really need to
    def verify_redirect_uri!
      # todo

      true
    end

    # TODO do we also need to verify :resource (not implemented)
    def verify_resource!
      true
    end

    # if PKCE code challenge is required and
    # code_verifier required if client_secret not present (SPA apps), otherwise it's a nice-to-have and should
    # be verified if present. Bad code == attempted intercept attack.
    def verify_code!
      @auth_code = AuthorizationCode.find_by!(client_id:, code:)

      # if these don't match we need to return an "invalid_grant" error
      Oauth::PKCE.code_challenge_match?(code_verifier, @auth_code.code_challenge)
    rescue => e
      # should this be rescuing from RecordNotFound errors? for the AuthCode lookup?
      #   Basically an InvalidRequest becuase of the bad code??
      Rails.logger.debug("[ERROR] Oauth::AuthorizationCodeFlow#verify_code! => #{e.message}")
    end
  end
end
