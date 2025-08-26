# Created after a user is shown a consent screen and agrees to login with X client
# this can be references on subsequent logins if scopes match then consent screen can
# be skipped

# this can also be deleted to "revoke" consent on behalf of the user.
class UserConsent < ApplicationRecord
  belongs_to :user
  belongs_to :client
end
