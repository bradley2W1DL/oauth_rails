module Oauth::Errors
  class InvalidGrantError < BaseError
    def base_message
      "Invalid Grant" # todo what should this actually say?
    end
  end
end
