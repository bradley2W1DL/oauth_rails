# helper methods to generate code_verifier / challenge combo
#
# from https://www.oauth.com/oauth2-servers/pkce/
#
# Proof Key for Code Exchange (abbreviated PKCE, pronounced “pixie”) is an extension to the authorization code flow 
# to prevent CSRF and authorization code injection attacks. The technique involves the client first creating a secret 
# on each authorization request, and then using that secret again when exchanging the authorization code for an access token.
# This way if the code is intercepted, it will not be useful since the token request relies on the initial secret.
#
module Oauth
  class Pkce
    LENGTH = 42

    class << self
      #
      # generate a random code_verifier string / code_challenge (SHA256) encoded
      # 
      # @return [verifier String, challenge String]
      def generate_code_verifier_and_challenge
        verifier = SecureRandom.urlsafe_base64(LENGTH)
        challenge = Base64.encode64(Digest::SHA256.hexdigest(verifier))

        [verifier, challenge, "S256"]
      end
    end
  end
end
