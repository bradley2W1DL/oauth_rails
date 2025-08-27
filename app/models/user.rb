class User < ApplicationRecord
  include ActiveModel::SecurePassword
  has_secure_password

  has_many :sessions, class_name: "UserSession", dependent: :destroy
end
