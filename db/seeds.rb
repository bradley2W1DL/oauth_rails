# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

# Seed an initial user
User.find_or_create_by!(username: "test@example.com", name: "Mister Test") do |user|
  user.password = "password"
  user.password_confirmation = "password"
end

Client.find_or_create_by!(name: "First App", redirect_uris: %w[localhost:4000/oauth_callback])
