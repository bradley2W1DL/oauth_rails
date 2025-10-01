# Oauth Module

This module implements some of the basic components for generating JWTs and signing them with an asymmetric ECDSA (ES256)
keypair

## JWT

## JWK

the `generate` method will create a ECDSA keypair and JWK using that keypair.  It will be stored in the jwks database
defaulting to an "active" state.

This key is stored as an encrypted JSON string using the ActiveRecord encryption built in functionality.

To initialize a new environment encryption keys need to be generated and added to the credentials file:
`rails db:encryption:init` => outputs credentials to be copy-pasta'd into creds file
`rails credentials:edit` <= make'a the copy-pasta 🍝
  (_note: this requires a "config/master.key" value for a given env_)


**todo**: need to implement an automatic rotation for these keys that will deactivate all current keys and activate a 
freshly generated one.  Also need to destroy any key that was de-activated over 1 month ago.
