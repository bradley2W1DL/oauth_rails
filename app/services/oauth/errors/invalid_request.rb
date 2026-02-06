module Oauth::Errors
  class InvalidRequest < Base
    def initialize(message:, error: "invalid_request")
      super
    end
  end
end
