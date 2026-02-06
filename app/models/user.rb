class User < ApplicationRecord
  include ActiveModel::SecurePassword

  has_secure_password

  has_many :sessions, class_name: "UserSession", dependent: :destroy
  has_many :consents, class_name: "UserConsent", dependent: :destroy

  scope :with_active_session, -> { joins(:sessions).where("user_sessions.expires_at > ?", Time.current) }

  # @param factor <String> email, username value
  # @return User instance
  # @throw ActiveRecord::RecordNotFound if no user found
  # @throw ActiveRecord::SoleRecordExceeded if more than one user found
  def self.find_by_factor(factor)
    find_sole_by("username = :factor OR email = :factor", factor:)
  end

  # TODO this method not working
  def consented_to?(client, scopes)
    consents.for_client(client).with_scopes(scopes).any?
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string
#  name                   :string
#  password_digest        :string
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
