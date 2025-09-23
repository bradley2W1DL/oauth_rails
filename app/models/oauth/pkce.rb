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
    LENGTH = 50 # arbitrary
    class << self
      ###
      # Generate a random code_verifier string / code_challenge (SHA256) encoded
      #
      # @return [verifier String, challenge String, challenge_method String]
      def generate_code_verifier_and_challenge
        verifier = SecureRandom.urlsafe_base64(LENGTH)
        challenge = hash_sha_256 verifier

        [verifier, challenge, "S256"]
      end

      ###
      # @param :authorization_code AuthorizationCode
      # @param :code_verifier String
      #
      # @return Boolean
      def valid_code_verifier?(auth_code, code_verifier)
        if auth_code.code_challenge_method == "plain"
          auth_code.code_challenge == code_verifier
        else
          hash_sha_256(auth_code.code_challenge) == code_verifier
        end
      end

      ### 
      # @params :code String
      #
      # @return String
      def hash_sha_256(code)
        Base64.urlsafe_encode64(Digest::SHA256.hexdigest(code))
      end
    end
  end
end
