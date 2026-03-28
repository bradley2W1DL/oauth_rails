FactoryBot.define do
  factory :client do
    name { "Test Client" }
    application_type { :confidential_client }
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
