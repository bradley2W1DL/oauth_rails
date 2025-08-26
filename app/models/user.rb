class User < ApplicationRecord
  include ActiveModel::SecurePassword
  has_secure_password

  has_many :user_sessions, dependent: :destroy
end
