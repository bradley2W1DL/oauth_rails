module Oauth
  class AuthorizationCodeFlow
    attr_reader :redirect_uri, :code, :code_verifier, :client

    def initialize(client_id:, redirect_uri:, grant_type:, code: nil, code_verifier: nil, client_secret: nil)
      if grant_type != "authorization_code"
        # this request should be handled by some other service
        raise RuntimeError.new "Invalid grant_type: #{grant_type} passed to Oauth::AuthorizationCodeFlow service"
      end

      if client_secret.nil? && code_verifier.nil?
        # public clients MUST use code_verifier for Proof Key for Code Exchange (PKCE)
        raise Errors::InvalidRequest.new(message: "code_verifier is required for PKCE auth code requests")
      end

      @code = code
      @code_verifier = code_verifier
      # if client_secret is present ensure it's a part of this query. If not, PKCE must be enforced
      client_params = { client_id:, client_secret: }.compact
      @client = Client.find_by!(client_params)
    end

    def generate_access_token!
      verify_redirect_uri!
      verify_code!

      # todo this class doesn't exist yet! What would go into this?
      # those should be a JWT...tbd
      Oauth::AccessToken.new
    end

    private

    # Check that the redirect URI on the incoming request matches the URI registerd on the AuthCode initial request
    # I mismatch here indicates a potential interception attack or similar shenanigans
    #   - this is extra verification that SHOULD happen but doesn't really need to
    def verify_redirect_uri!
      # todo
      true
    end

    # if PKCE code challenge is required and 
    # code_verifier required if client_secret not present (SPA apps), otherwise it's a nice-to-have and should
    # be verified if present. Bad code == attempted intercept attack.
    def verify_code!
      begin
        @auth_code = AuthorizationCode.find_by!(client_id:, code:)

        # if these don't match we need to return an "invalid_grant" error
        Oauth::PKCE.code_challenge_match?(code_verifier, @auth_code.code_challenge)
      rescue StandardError => e
        # should this be rescuing from RecordNotFound errors? for the AuthCode lookup?
        #   Basically an InvalidRequest becuase of the bad code??
        Rails.logger.debug("[ERROR] Oauth::AuthorizationCodeFlow#verify_code! => #{e.message}")
      ensure
        # ensure auth code is destroyed after it's verified (one-time-use only)
        @auth_code&.destroy
      end
    end

    private
  end
end
