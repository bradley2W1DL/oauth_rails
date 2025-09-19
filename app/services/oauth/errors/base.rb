module Oauth::Errors
  class Base < StandardError
    attr_reader :error, :message, :status
    def initialize(error:, message: "big badda boom", status: 422)
      @error = error
      @message = message
      @status = status
    end

    # def to_json
    #   {}
    # end
  end
end

