# OAuth 2.0 Authorization Flows

Based on RFC 6749 (The OAuth 2.0 Authorization Framework), this document outlines the four main authorization grant types with detailed sequence diagrams.

## 1. Authorization Code Grant

**Use Case**: Most secure flow for confidential clients (server-side applications)
**Security Level**: High - provides client authentication and separates authorization code from access token

```mermaid
sequenceDiagram
    participant RO as Resource Owner<br/>(User)
    participant C as Client<br/>(Application)
    participant AS as Authorization Server
    participant RS as Resource Server

    Note over RO,RS: Step 1: Authorization Request
    C->>RO: Redirect to Authorization Server
    Note right of C: GET /authorize?response_type=code<br/>&client_id=CLIENT_ID<br/>&redirect_uri=REDIRECT_URI<br/>&scope=SCOPE&state=STATE

    Note over RO,RS: Step 2: User Authentication & Consent
    RO->>AS: Login credentials
    AS->>RO: Present consent screen
    RO->>AS: Grant permission

    Note over RO,RS: Step 3: Authorization Grant
    AS->>RO: Redirect with authorization code
    Note right of AS: HTTP 302<br/>Location: REDIRECT_URI?code=AUTH_CODE<br/>&state=STATE
    RO->>C: Follow redirect (delivers code)

    Note over RO,RS: Step 4: Access Token Request
    C->>AS: Exchange code for token
    Note right of C: POST /token<br/>grant_type=authorization_code<br/>&code=AUTH_CODE<br/>&redirect_uri=REDIRECT_URI<br/>&client_id=CLIENT_ID
    AS->>C: Access token response
    Note right of AS: {"access_token": "TOKEN",<br/>"token_type": "Bearer",<br/>"expires_in": 3600}

    Note over RO,RS: Step 5: Access Protected Resource
    C->>RS: Request with access token
    Note right of C: Authorization: Bearer TOKEN
    RS->>AS: Validate token (optional)
    AS->>RS: Token validation response
    RS->>C: Protected resource data
```

**Parameters:**
- **Authorization Request**: `response_type=code`, `client_id`, `redirect_uri`, `scope`, `state`
- **Token Request**: `grant_type=authorization_code`, `code`, `redirect_uri`, `client_id`, `client_secret`

---

## 2. Implicit Grant - DEPRECATED

**Use Case**: Browser-based applications (SPAs) - **DEPRECATED in OAuth 2.1**
**Security Level**: Medium - no client authentication, token exposed in URI

```mermaid
sequenceDiagram
    participant RO as Resource Owner<br/>(User)
    participant C as Client<br/>(Browser App)
    participant AS as Authorization Server
    participant RS as Resource Server

    Note over RO,RS: Step 1: Authorization Request
    C->>RO: Redirect to Authorization Server
    Note right of C: GET /authorize?response_type=token<br/>&client_id=CLIENT_ID<br/>&redirect_uri=REDIRECT_URI<br/>&scope=SCOPE&state=STATE

    Note over RO,RS: Step 2: User Authentication & Consent
    RO->>AS: Login credentials
    AS->>RO: Present consent screen
    RO->>AS: Grant permission

    Note over RO,RS: Step 3: Access Token (Direct)
    AS->>RO: Redirect with access token in fragment
    Note right of AS: HTTP 302<br/>Location: REDIRECT_URI#access_token=TOKEN<br/>&token_type=Bearer&expires_in=3600<br/>&state=STATE
    RO->>C: Follow redirect (delivers token)
    C->>C: Extract token from URL fragment

    Note over RO,RS: Step 4: Access Protected Resource
    C->>RS: Request with access token
    Note right of C: Authorization: Bearer TOKEN
    RS->>AS: Validate token (optional)
    AS->>RS: Token validation response
    RS->>C: Protected resource data
```

**Parameters:**
- **Authorization Request**: `response_type=token`, `client_id`, `redirect_uri`, `scope`, `state`
- **Token Response**: `access_token`, `token_type`, `expires_in`, `scope`, `state`

---

## 3. Resource Owner Password Credentials Grant - DEPRECATED

**Use Case**: Highly trusted clients only (first-party applications) **DEPRECATED in OAuth 2.1**
**Security Level**: Low - requires sharing user credentials with client

```mermaid
sequenceDiagram
    participant RO as Resource Owner<br/>(User)
    participant C as Client<br/>(Trusted App)
    participant AS as Authorization Server
    participant RS as Resource Server

    Note over RO,RS: Step 1: Credential Collection
    RO->>C: Provide username & password
    Note right of RO: User enters credentials<br/>directly into client

    Note over RO,RS: Step 2: Access Token Request
    C->>AS: Request token with user credentials
    Note right of C: POST /token<br/>grant_type=password<br/>&username=USERNAME<br/>&password=PASSWORD<br/>&client_id=CLIENT_ID<br/>&client_secret=CLIENT_SECRET
    AS->>AS: Validate user credentials
    AS->>C: Access token response
    Note right of AS: {"access_token": "TOKEN",<br/>"token_type": "Bearer",<br/>"expires_in": 3600}

    Note over RO,RS: Step 3: Discard Credentials
    C->>C: Delete stored credentials
    Note right of C: Client MUST discard<br/>username/password

    Note over RO,RS: Step 4: Access Protected Resource
    C->>RS: Request with access token
    Note right of C: Authorization: Bearer TOKEN
    RS->>AS: Validate token (optional)
    AS->>RS: Token validation response
    RS->>C: Protected resource data
```

**Parameters:**
- **Token Request**: `grant_type=password`, `username`, `password`, `client_id`, `client_secret`, `scope`

---

## 4. Client Credentials Grant

**Use Case**: Machine-to-machine authentication (no user involved)
**Security Level**: Medium - depends on client credential security

```mermaid
sequenceDiagram
    participant C as Client<br/>(Service/App)
    participant AS as Authorization Server
    participant RS as Resource Server

    Note over C,RS: Step 1: Access Token Request
    C->>AS: Request token with client credentials
    Note right of C: POST /token<br/>grant_type=client_credentials<br/>&client_id=CLIENT_ID<br/>&client_secret=CLIENT_SECRET<br/>&scope=SCOPE
    AS->>AS: Validate client credentials
    AS->>C: Access token response
    Note right of AS: {"access_token": "TOKEN",<br/>"token_type": "Bearer",<br/>"expires_in": 3600}

    Note over C,RS: Step 2: Access Protected Resource
    C->>RS: Request with access token
    Note right of C: Authorization: Bearer TOKEN
    RS->>AS: Validate token (optional)
    AS->>RS: Token validation response
    RS->>C: Protected resource data
```

**Parameters:**
- **Token Request**: `grant_type=client_credentials`, `client_id`, `client_secret`, `scope`

---

## 5. Refresh Token Flow

**Use Case**: Obtaining new access tokens without user re-authentication
**Security Level**: High - allows long-term access with proper rotation

```mermaid
sequenceDiagram
    participant C as Client
    participant AS as Authorization Server
    participant RS as Resource Server

    Note over C,RS: Prerequisites: Client has refresh token from previous flow

    Note over C,RS: Step 1: Access Token Expired
    C->>RS: Request with expired access token
    RS->>C: HTTP 401 Unauthorized

    Note over C,RS: Step 2: Refresh Token Request
    C->>AS: Exchange refresh token for new access token
    Note right of C: POST /token<br/>grant_type=refresh_token<br/>&refresh_token=REFRESH_TOKEN<br/>&client_id=CLIENT_ID<br/>&client_secret=CLIENT_SECRET
    AS->>AS: Validate refresh token
    AS->>C: New access token (and optionally new refresh token)
    Note right of AS: {"access_token": "NEW_TOKEN",<br/>"token_type": "Bearer",<br/>"expires_in": 3600,<br/>"refresh_token": "NEW_REFRESH_TOKEN"}

    Note over C,RS: Step 3: Retry with New Token
    C->>RS: Request with new access token
    Note right of C: Authorization: Bearer NEW_TOKEN
    RS->>C: Protected resource data
```

**Parameters:**
- **Refresh Request**: `grant_type=refresh_token`, `refresh_token`, `client_id`, `client_secret`, `scope`

---

## Security Considerations by Flow

### Authorization Code Grant
- ✅ **Most Secure**: Client authentication, code/token separation
- ✅ **Recommended for**: Server-side applications
- ✅ **Use with**: PKCE for public clients

### Implicit Grant
- ⚠️ **Deprecated**: Use Authorization Code + PKCE instead
- ❌ **Issues**: Token in URL, no client authentication
- 📝 **Legacy only**: Consider migration to Authorization Code

### Resource Owner Password Credentials
- ⚠️ **High Trust Required**: Only for first-party applications
- ❌ **Risks**: Credential exposure, credential storage
- 📝 **Limited Use**: When redirect-based flows aren't feasible

### Client Credentials
- ✅ **Good for**: Service-to-service authentication
- ✅ **No User Context**: Machine-to-machine only
- 🔒 **Secure Storage**: Client secret must be protected

---

## 6. Authorization Code Grant with PKCE (RFC 7636)

**Use Case**: Enhanced security for public clients (mobile apps, SPAs) and recommended for all clients
**Security Level**: Very High - prevents authorization code interception attacks

```mermaid
sequenceDiagram
    participant RO as Resource Owner<br/>(User)
    participant C as Client<br/>(Public Client)
    participant AS as Authorization Server
    participant RS as Resource Server

    Note over RO,RS: Step 0: PKCE Preparation
    C->>C: Generate code_verifier (43-128 chars)
    C->>C: Derive code_challenge = SHA256(code_verifier)
    Note right of C: code_verifier: dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk<br/>code_challenge: E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM

    Note over RO,RS: Step 1: Authorization Request with PKCE
    C->>RO: Redirect to Authorization Server
    Note right of C: GET /authorize?response_type=code<br/>&client_id=CLIENT_ID<br/>&redirect_uri=REDIRECT_URI<br/>&scope=SCOPE&state=STATE<br/>&code_challenge=E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM<br/>&code_challenge_method=S256

    Note over RO,RS: Step 2: User Authentication & Consent
    RO->>AS: Login credentials
    AS->>RO: Present consent screen
    RO->>AS: Grant permission

    Note over RO,RS: Step 3: Authorization Server Stores Challenge
    AS->>AS: Store code_challenge and method
    AS->>RO: Redirect with authorization code
    Note right of AS: HTTP 302<br/>Location: REDIRECT_URI?code=AUTH_CODE<br/>&state=STATE
    RO->>C: Follow redirect (delivers code)

    Note over RO,RS: Step 4: Token Request with Code Verifier
    C->>AS: Exchange code for token with verifier
    Note right of C: POST /token<br/>grant_type=authorization_code<br/>&code=AUTH_CODE<br/>&redirect_uri=REDIRECT_URI<br/>&client_id=CLIENT_ID<br/>&code_verifier=dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk

    Note over RO,RS: Step 5: PKCE Verification
    AS->>AS: Verify: SHA256(code_verifier) == stored code_challenge
    AS->>C: Access token response (if verified)
    Note right of AS: {"access_token": "TOKEN",<br/>"token_type": "Bearer",<br/>"expires_in": 3600}

    Note over RO,RS: Step 6: Access Protected Resource
    C->>RS: Request with access token
    Note right of C: Authorization: Bearer TOKEN
    RS->>AS: Validate token (optional)
    AS->>RS: Token validation response
    RS->>C: Protected resource data
```

**PKCE Parameters:**
- **Authorization Request**: `code_challenge`, `code_challenge_method` (S256 or plain)
- **Token Request**: `code_verifier` (original random string)

**Code Challenge Methods:**
- **S256** (Recommended): `code_challenge = BASE64URL(SHA256(code_verifier))`
- **plain**: `code_challenge = code_verifier` (fallback only)

**Security Benefits:**
- ✅ **Prevents Code Interception**: Even if authorization code is stolen, attacker can't exchange it without code_verifier
- ✅ **No Client Secret Required**: Perfect for public clients (mobile/SPA)
- ✅ **Cryptographic Proof**: Mathematically proves client generated the original request
- ✅ **Mandatory in OAuth 2.1**: Now required for all clients

---

## Attack Scenarios PKCE Prevents

### Without PKCE - Code Interception Attack:
```mermaid
sequenceDiagram
    participant U as User
    participant A as Legitimate App
    participant M as Malicious App
    participant AS as Auth Server

    A->>U: Redirect to authorization
    U->>AS: Authorize legitimate app
    AS->>U: Redirect with code
    Note over M: Malicious app intercepts redirect
    M->>AS: Exchange stolen code for token
    AS->>M: Issues access token ❌
```

### With PKCE - Attack Prevented:
```mermaid
sequenceDiagram
    participant U as User
    participant A as Legitimate App
    participant M as Malicious App
    participant AS as Auth Server

    A->>A: Generate code_verifier + code_challenge
    A->>U: Redirect with code_challenge
    U->>AS: Authorize with code_challenge
    AS->>U: Redirect with code
    Note over M: Malicious app intercepts redirect
    M->>AS: Try to exchange code (no code_verifier)
    AS->>M: Reject - missing code_verifier ✅
    A->>AS: Exchange code with correct code_verifier
    AS->>A: Issues access token ✅
```

---

## Modern Best Practices (OAuth 2.1)

1. **Use Authorization Code + PKCE** for all client types
2. **Always use S256 code challenge method** (never plain)
3. **Generate high-entropy code_verifier** (minimum 256 bits)
4. **Implement refresh token rotation**
5. **Use short-lived access tokens**
6. **Always use HTTPS/TLS**
7. **Implement proper state parameter validation**
8. **Consider using JWT for structured tokens**
