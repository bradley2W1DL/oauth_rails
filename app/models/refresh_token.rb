class RefreshToken < ApplicationRecord
  belongs_to :client
  belongs_to :user
  belongs_to :session
end

# == Schema Information
#
# Table name: refresh_tokens
#
#  id              :integer          not null, primary key
#  expires_at      :datetime
#  issued_at       :datetime
#  parent_token    :integer
#  revoked         :boolean          default(FALSE)
#  scopes          :json
#  token           :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  client_id       :integer          not null
#  user_id         :integer          not null
#  user_session_id :integer          not null
#
# Indexes
#
#  index_refresh_tokens_on_client_id        (client_id)
#  index_refresh_tokens_on_user_id          (user_id)
#  index_refresh_tokens_on_user_session_id  (user_session_id)
#
# Foreign Keys
#
#  client_id        (client_id => clients.id)
#  user_id          (user_id => users.id)
#  user_session_id  (user_session_id => user_sessions.id)
#
