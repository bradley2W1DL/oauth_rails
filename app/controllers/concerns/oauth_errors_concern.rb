module OauthErrorsConcern
  extend ActiveSupport::Concern

  # todo rescue from all the Oauth::Errors here, returning the appropriate responses.
  # e.g.
  # rescue_from Oauth::Errors::InvalidClientError, with: :invalid_client
end
