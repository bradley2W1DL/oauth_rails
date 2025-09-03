class User < ApplicationRecord
  include ActiveModel::SecurePassword
  has_secure_password

  has_many :sessions, class_name: "UserSession", dependent: :destroy

  def self.find_by_factor(factor)
    # username or password for the time being
    # throw an error if more than one found
    users = where("username = :factor OR email = :factor", factor:)
    raise ActiveRecord::RecordNotFound, "Multiple users found" if users.size > 1

    users.last
  end
end
