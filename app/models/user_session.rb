class UserSession < ApplicationRecord
  belongs_to :user

  has_many :authorization_codes, dependent: :destroy
  has_many :refresh_tokens, dependent: :destroy
end
