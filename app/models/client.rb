class Client < ApplicationRecord
  before_create :generate_id_and_secret

  enum :application_type, {
    public: 0,
    confidential: 1
  }

  private

  def generate_id_and_secret
    # uuid_v7 has a concept of time ordering which is better for indexing
    self.client_id = SecureRandom.uuid_v7
    self.client_secret = SecureRandom.hex(30)
  end
end
