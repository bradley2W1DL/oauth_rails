module Oauth
  class AuthorizationCodeService
    attr_reader :code, :code_verifier, :client, :redirect_uri

    def initialize(client_id:, client_secret: nil, redirect_uri:, code:, code_verifier: nil)
      @code = code
      @code_verifier = code_verifier
      @redirect_uri = redirect_uri
      client_params = {client_id:}
      client_params[:client_secret] = client_secret if client_secret.present? || !code_verifier
      
      @client = Client.find_by!(client_params) # what error do we want this to return?
      @authorization_code = AuthorizationCode.find_by!(code:, client: @client, redirect_uri:)
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.debug(e.message)
      # Client or AuthorizationCode not found...what should API return for this? "invalid_grant"?
      raise ::Oauth::Error::RecordNotFound(e)
    end

    def self.validate!(**args)
      new(**args).validate!
    end

    def validate!
      validate_pkce_verifier! if code_verifier
    end

    # @return void
    def verify_pkce_verifier!
      unless Oauth::Pkce.valid_code_verifier?(@authorization_code, code_verifier)
        raise ::Oauth::Errors::InvalidGrant
      end
    end
  end
end
