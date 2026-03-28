# What needs to get T'DONE?

Tracking this projects progress and features yet to implement.

## Access Tokens

- [x] Implement a class that can generate a **signed** JWT with all require claims
  - Access Token Claims: iss, sub, aud, exp, iat, nbf, scope, and jti
  - The Refresh token can be opaque or a JWT containing the same claims as the Access Token, but with a "token_use/type" 
  attribute of "refresh_token"
  - JWTs signed with the currently active JWK

## JWKs endpoints

- [x] Be able to fetch a JWKS (JSON Web Key Set) for public keys that can be used to verify token authenticity
  - serve this as the standard JWKS array from "/.well-known/jwks.json"
- [x] Generate JWKS with the EdDSA algorithm and persist the private key in the database, retrievable for JWT signing 
  - [x] Rake task to create and persist JWK with timestamps to be used for rotation/expiration
- [ ] Implement a JWK rotation strategy to generate new keys on a time interval and return both previous and new keys for some period of time.

## Authorization Code Grant types

- [x] authorization_code
  - [ ] Implement redirect_uri verification. May require accessing request context in some way.
- [x] client_credentials
  - (this is a direct post to the token endpoint)
- [ ] refresh_token
  - This needs to include adding a refresh token to minted access tokens; conditional based on "scopes" arg.

## Additional Features of this as a standalone auth server

- [ ] Additional "resources" pages that render the lib Oauth flow markdown files
  - Can markdown be rendered in a Rails app easily?
- [ ] Client App registration -- allow other apps (mine) to use this server for their auth
  - need to review the trusted client parts of the Oauth2 spec
  - be careful with this

### DX / housekeeping things

- [ ] Add the "annotaterb" gem to add nice model schema comments
