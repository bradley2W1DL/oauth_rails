# Rake tasks for JSON Web Key (JWK) management

namespace :jwks do
  desc "generate JWK and persist to the database"
  task generate_key: :environment do
    Rails.logger.info "-------------- Creating a new JWK"
    key = JsonWebKey.generate
    Rails.logger.info "Success! kid: #{key.kid}"
  end
end
