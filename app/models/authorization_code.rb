class AuthorizationCode < ApplicationRecord
  belongs_to :client
  belongs_to :user, optional: true
  belongs_to :user_session, optional: true
end
