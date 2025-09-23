module Oauth
  class AuthorizationCodeService
    attr_reader :code, :code_verifier, :client, :redirect_uri

    def initialize(client_id:, client_secret: nil, redirect_uri:, code:, code_verifier: nil)
      @code = code
      @code_verifier = code_verifier
      @redirect_uri = redirect_uri

      client_params = {client_id:}
      client_params[:client_secret] = client_secret if client_secret.present? || !code_verifier
      @client = Client.find_by! client_params
    end

    def self.generate_access_token!(**args)
      new(**args).generate_access_token!
    end

    def generate_access_token!
      validate_pkce_verifier! if code_verifier

      # todo you are here, call Jwt service...
      # Oauth::AccessToken.jwt
    end

    # @return void
    def verify_pkce_verifier!
      auth_code = AuthorizationCode.find_by!(code:, client:)

      valid = Oauth::Pkce.valid_code_verifier?(auth_code, code_verifier)

      raise ::Oauth::Errors::InvalidGrant unless valid
    end
  end
end
