module Oauth
  class AuthorizationCode
    class << self
      def verify_code!(client_id:, redirect_uri:, grant_type:, code: nil, code_verifier: nil, client_secret: nil)
        # first fetch client ID
        Client.find_by!(client_id: params[:client_id])

        case grant_type
        when "authorization_code"
          verify_authorization_code!
        end
        true
      end
    end
  end
end
