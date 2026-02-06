class AuthorizationCode < ApplicationRecord
  EXPIRATION_MINUTES = 5

  belongs_to :client
  belongs_to :user, optional: true
  belongs_to :user_session, optional: true

  before_create :generate_code

  def expired?
    created_at < EXPIRATION_MINUTES.minutes.ago
  end

  private

  # @return [UUID] (36 characters in length)
  def generate_code
    self.code = SecureRandom.uuid
  end
end

# == Schema Information
#
# Table name: authorization_codes
#
#  id                    :integer          not null, primary key
#  code                  :string           default("000"), not null
#  code_challenge        :text
#  code_challenge_method :string
#  redirect_uri          :text
#  scopes                :json
#  state                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  client_id             :integer          not null
#  user_id               :integer
#  user_session_id       :integer
#
# Indexes
#
#  index_authorization_codes_on_client_id        (client_id)
#  index_authorization_codes_on_user_id          (user_id)
#  index_authorization_codes_on_user_session_id  (user_session_id)
#
# Foreign Keys
#
#  client_id        (client_id => clients.id)
#  user_id          (user_id => users.id)
#  user_session_id  (user_session_id => user_sessions.id)
#
