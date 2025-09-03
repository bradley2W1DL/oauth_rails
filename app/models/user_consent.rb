# Created after a user is shown a consent screen and agrees to login with X client
# this can be references on subsequent logins if scopes match then consent screen can
# be skipped

# this can also be deleted to "revoke" consent on behalf of the user.
class UserConsent < ApplicationRecord
  belongs_to :user
  belongs_to :client
  before_save :sort_scopes

  scope :for_client, ->(client){ where(client:) }
  scope :with_scopes, ->(scopes = []) { where(scopes: scopes.sort)}

  # this will make json comparison easier...hopefully
  def sort_scopes
    self.scopes = scopes.sort if scopes_changed?
  end
end
