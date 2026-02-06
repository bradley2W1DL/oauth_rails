class Client < ApplicationRecord
  encrypts :client_secret

  before_create :generate_id_and_secret

  enum :application_type, {
    public_client: 0,
    confidential_client: 1
  }

  private

  def generate_id_and_secret
    self.client_id = SecureRandom.uuid
    self.client_secret = SecureRandom.hex(30)
  end
end

# == Schema Information
#
# Table name: clients
#
#  id               :integer          not null, primary key
#  application_type :integer
#  client_secret    :string
#  name             :string
#  redirect_uris    :json
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  client_id        :string
#
