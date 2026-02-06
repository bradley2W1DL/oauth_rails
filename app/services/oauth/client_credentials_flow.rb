module Oauth
  class ClientCredentialsFlow < OauthBase
    attr_reader :client, :client_id, :client_secret, :scopes

    self.klass_grant_type = :client_credentials

    def initialize(client_id:, client_secret:, grant_type:, scopes: [])
      super(grant_type:)

      if client_id.nil? || client_secret.nil?
        raise Errors::InvalidRequest.new(error: "invalid_request", message: "client_id and client_secret required for the 'client_credentials' flow")
      end

      @client = Client.find_by(client_id:)
      raise ActiveRecord::RecordNotFound if @client.nil?

      @client_id = client_id
      @client_secret = client_secret
      @scopes = scopes
    end

    def generate_access_token!
      if client_secret != client.client_secret
        raise Errors::InvalidRequest.new(error: "invalid_request", message: "Invalid client_id or client_secret")
      end

      Oauth::AccessToken.new(client_id:, subject: client, scopes:)
    end
  end
end