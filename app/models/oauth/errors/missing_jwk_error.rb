module Oauth::Errors
  class MissingJwkError < BaseError
    def base_message(_msg)
      "No active JWK found for signing tokens"
    end
  end
end
