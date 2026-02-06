class UserSession < ApplicationRecord
  DEFAULT_SESSION_LENGTH = 7 # days

  belongs_to :user

  has_many :authorization_codes, dependent: :destroy
  has_many :refresh_tokens, dependent: :destroy

  before_create :generate_token_with_expiration

  def expired?
    expires_at < Time.current
  end

  private

  def generate_token_with_expiration
    self.token = SecureRandom.hex(30)
    self.expires_at = DEFAULT_SESSION_LENGTH.days.from_now
  end
end

# == Schema Information
#
# Table name: user_sessions
#
#  id          :integer          not null, primary key
#  expires_at  :datetime         not null
#  ip_address  :string
#  last_active :datetime
#  token       :string           not null
#  user_agent  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer          not null
#
# Indexes
#
#  index_user_sessions_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
