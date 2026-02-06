module Oauth
  class OauthBase
    class_attribute :klass_grant_type
    self.klass_grant_type = nil # override this in subclasses

    def initialize(grant_type:, **args)
      if self.klass_grant_type.nil?
        raise NotImplementedError.new("klass_grant_type must be defined in subclass. not implemented in #{__FILE__}")
      end

      if grant_type != self.klass_grant_type.to_s
        raise ArgumentError.new("Invalid grant_type: #{grant_type} passed to #{self.class.name} service")
      end
    end

    def generate_access_token!
      raise NotImplementedError.new("generate_access_token! not implemented in #{self.class.name}")
    end
  end
end
