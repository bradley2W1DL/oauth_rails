module Oauth::Errors
  class InvalidGrantTypeError < BaseError
    def base_message(message)
      "Unsupported grant type: #{message}"
    end
  end
end
