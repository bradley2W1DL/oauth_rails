# What needs to get T'DONE?

Tracking this projects progress and features yet to implement.

## Access Tokens

- [ ] Implement a class that can generate a signed JWT with all require claims
  - Access Token Claims: iss, sub, aud, exp, iat, nbf, scope, and jti
  - The Refresh token can be opaque or a JWT containing the same claims as the Access Token, but with a "token_use/type" 
  attribute of "refresh_token"

## JWKs endpoints

- [ ] Be able to fetch a JWKS (JSON Web Key Set) for public keys that can be used to verify token authenticity

## Authorization Code Grant types

- [x] authorization_code
- [ ] client_credentials
- [ ] refresh_token

