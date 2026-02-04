# JWT Access Tokens

The JWT access token profile describes a way to encode tokens as JSON Web Tokens, including a set of standard claims
that are useful in an access token.

JWTs can be use as OAuth 2.0 Bearer Tokens to encode all relevant parts fo an access token into the access token itself
instead of having to store them in a database.

[OAuth 2.0 link](https://oauth.net/2/jwt-access-tokens/)

___

Short version Access Token vs Refresh Token

• JWTs for refreshable tokens are usually two tokens: an access token (short‑lived) and a refresh token (long‑lived).
The access token is a JWT with claims like iss, sub, aud, exp, iat, nbf, scope, and jti, signed (e.g., RS256) and
verifiable via the issuer’s JWKS. The refresh token can be opaque or a JWT containing claims such as iss, sub, aud,
exp, iat, jti, scope, and a token_use/type (e.g., “refresh_token”). Many providers rotate the refresh token on use for
security.

• Refresh without a client_secret (public clients): the token endpoint is often able to authenticate the client_id
only (no secret) or uses MTLS/DPoP for binding. The client sends grant_type=refresh_token, refresh_token=..., and
client_id=... (and optionally scope). If valid, the server issues a new access_token and, if rotating, a
new_refresh_token (invalidating the old one). For stronger binding, consider MTLS/DPoP and always rotate tokens; PKCE
is not required for the refresh grant.
