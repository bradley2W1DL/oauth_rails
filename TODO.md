# What needs to get T'DONE?

Tracking this projects progress and features yet to implement.

## Access Tokens

- [ ] Implement a class that can generate a signed JWT with all require claims
  - Access Token Claims: iss, sub, aud, exp, iat, nbf, scope, and jti
  - The Refresh token can be opaque or a JWT containing the same claims as the Access Token, but with a "token_use/type" 
  attribute of "refresh_token"

## JWKs endpoints

- [ ] Be able to fetch a JWKS (JSON Web Key Set) for public keys that can be used to verify token authenticity
- [ ] Generate JWKs EC or RSA256 and persist the private key persisted in the database, retrievable for JWT signing
- [ ] Implement a JWK rotation strategy to generate new keys on a time interval and return both previous and new keys
for some period of time.

## Authorization Code Grant types

- [x] authorization_code
- [ ] client_credentials
- [ ] refresh_token

