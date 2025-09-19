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
