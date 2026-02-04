# Oauth Rails

Basic Oauth 2.1 compliant authorization server built with Rails.

Not really meant to be a production-ready server, but more of a way to learn about all of the aspects of the Oauth 2.0 authorization server role.

That said I do want to implement:

1. Client credentials flow
2. Code grant auth flow with support for the PKCE extension
  * Proof Key for Code Exchange
3. Persisted user records with access and refresh tokens 
4. FE to manage user records as an admin
  * As well as a way to "onboard" a new client


## Client usage

Expose an API that allows session management; revoking sessions, etc.
### Local Dev notes

Ensure you have redis service install and started. In my linux env redis is replaced with "valkey" (essential an open-source fork). Be sure to start the valkey service, or the trace caching feature won't work as expected.

```sh
systemctl start valkey.service
```

Credentials encryption keys are stored in 1Password, copy these down with the `bin/fetch-env-keys` script
_This requires that the `op` cli tool is installed and you're authenticated to correct 1Pass acct_
