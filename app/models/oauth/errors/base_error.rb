module Oauth::Errors
  class BaseError < StandardError
    attr_reader :error, :message, :status

    def initialize(error:, message:, status: 422)
      @error = error
      @message = base_message(message)
      @status = status
    end

    # def to_json
    #   {}
    # end

    def base_message(message)
      raise NotImplementedError, "Subclasses must implement the base_message method"
    end
  end
end
