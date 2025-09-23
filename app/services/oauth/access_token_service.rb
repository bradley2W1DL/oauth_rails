module Oauth
  class AccessTokenService
    class << self
      def generate_token!(grant_type:, client_id:, client_secret: nil, code: nil, code_verifier: nil, redirect_uri:)
        # really the different grant types are just stating HOW to verify the validity of the request
        # the actual token creation beyond that is the same, right?
        # I.e. each service should :validate_request(**params) and then return a boolean or w/e
        # this service can then continue to actually building the JWT
        case grant_type
        when "authorization_code"
          AuthorizationCodeService.generate_token!(client_id:, client_secret: nil, code:, code_verifier:)
        when "client_credentials"
          # TODO implement client credentials flow
          # ClientCredentialsService.generate_token!
          raise NotImplementedError, "I haven't gotten around to the client credentials flow yet, sorrrry!"
        else
          raise InvalidGrantTypeError, grant_type
        end
      end
    end
  end
end
