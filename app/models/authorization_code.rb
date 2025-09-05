class AuthorizationCode < ApplicationRecord
  belongs_to :client
  belongs_to :user, optional: true
  belongs_to :user_session, optional: true

  before_create :generate_code

  private

  def generate_code
    self.code = SecureRandom.uuid
  end
end
