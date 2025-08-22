class User < ApplicationRecord
  include ActiveModle::SecurePassword

  has_secure_password
end
