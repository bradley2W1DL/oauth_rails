class User < ApplicationRecord
  include ActiveModel::SecurePassword

  has_secure_password

  has_many :sessions, class_name: "UserSession", dependent: :destroy
  has_many :consents, class_name: "UserConsent", dependent: :destroy

  scope :with_active_session, -> { joins(:sessions).where("user_sessions.expires_at > ?", Time.current) }

  def self.find_by_factor(factor)
    # username or password for the time being
    # throw an error if more than one found
    users = where("username = :factor OR email = :factor", factor:)
    raise ActiveRecord::RecordNotFound, "Multiple users found" if users.size > 1

    users.last
  end

  # TODO this method not working
  def consented_to?(client, scopes)
    consents.for_client(client).with_scopes(scopes).any?
  end
end
