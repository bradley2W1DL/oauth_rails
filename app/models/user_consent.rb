# Created after a user is shown a consent screen and agrees to login with X client
# this can be references on subsequent logins if scopes match then consent screen can
# be skipped

# this can also be deleted to "revoke" consent on behalf of the user.
class UserConsent < ApplicationRecord
  belongs_to :user
  belongs_to :client

  scope :for_client, ->(client) { where(client:) }
  scope :with_scopes, ->(scopes = []) do
    return where(scopes: []) if scopes.empty?

    # subquery comparison on distinct / ordered values in scopes column
    sql = <<~SQL
      (
        SELECT json_group_array(DISTINCT value ORDER BY value) FROM json_each(scopes)
      ) = (
        SELECT json_group_array(DISTINCT value ORDER BY value) FROM json_each(?)
      )
    SQL

    where(sql, scopes.to_json)
  end
end
