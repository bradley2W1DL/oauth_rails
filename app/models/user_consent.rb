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

# == Schema Information
#
# Table name: user_consents
#
#  id         :integer          not null, primary key
#  scopes     :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  client_id  :integer          not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_user_consents_on_client_id  (client_id)
#  index_user_consents_on_user_id    (user_id)
#
# Foreign Keys
#
#  client_id  (client_id => clients.id)
#  user_id    (user_id => users.id)
#
