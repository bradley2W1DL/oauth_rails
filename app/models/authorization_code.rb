class AuthorizationCode < ApplicationRecord
  belongs_to :client
  belongs_to :user
  belongs_to :session
end
