module Oauth
  class AccessTokenService
    attr_reader :grant_type, :client_id, :client_secret, :code, :code_verifier, :redirect_uri

    def initialize(grant_type:, client_id:, redirect_uri:, client_secret: nil, code: nil, code_verifier: nil)
      @grant_type = grant_type
      @client_id = client_id
      @client_secret = client_secret
      @code = code
      @code_verifier = code_verifier
      @redirect_uri = redirect_uri
    end

    def self.generate_token!(**args)
      new(**args).generate_token
    end

    def generate_token
      # really the different grant types are just stating HOW to verify the validity of the request
      # the actual token creation beyond that is the same, right?
      # I.e. each service should :validate_request(**params) and then return a boolean or w/e
      # this service can then continue to actually building the JWT
      validate_request!

      Oauth::Jwt.generate_token(@client)
    end

    def validate_request!
      case grant_type
      when "authorization_code"
        AuthorizationCodeService.validate!(client_id:, client_secret:, code:, code_verifier:)
      when "client_credentials"
        # TODO implement client credentials flow
        # ClientCredentialsService.validate!(client_id:, client_secret:)
        raise NotImplementedError, "I haven't gotten around to the client credentials flow yet, sorrrry!"
      else
        raise InvalidGrantTypeError, grant_type
      end
    end
  end
end
