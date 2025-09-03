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
