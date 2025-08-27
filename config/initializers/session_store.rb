# # #
# Use cookie-based sessions 🍪 (default in Rails).
# Session data is signed & encrypted before being stored in the browser.
# Keep it lightweight (IDs, flags), not entire objects.
Rails.application.config.session_store :cookie_store,
  key: "_auth_session",
  # Expiration: by default, session cookie ends when browser closes.
  # Set expire_after to persist sessions across browser restarts.
  expire_after: 14.days,
  # Security settings:
  secure: Rails.env.production?,  # Only send cookie over HTTPS in production
  httponly: true,                 # Prevent JavaScript from accessing the cookie
  same_site: :lax                 # CSRF protection. Options: :lax (default), :strict, :none (requires secure: true),
