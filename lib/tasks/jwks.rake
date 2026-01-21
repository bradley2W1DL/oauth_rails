# Rake tasks for JSON Web Key (JWK) management

namespace :jwks do
  desc "generate JWK and persist to the database"
  task generate_key: :environment do
    puts "makey a key plz"
  end
end
