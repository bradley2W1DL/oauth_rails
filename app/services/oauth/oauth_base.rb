module Oauth
  class OauthBase
    def generate_access_token!
      raise NotImplementedError.new("generate_access_token! not implmented in #{__FILE__}")
    end
  end
end
