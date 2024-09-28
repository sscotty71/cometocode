# Policy per generare token
path "auth/token/create" {
  capabilities = ["read", "list", "create", "update"]
}

path "sys/mounts" {
  capabilities = ["read", "list"]
}

path "cometocode-secrets/*" {
  capabilities = ["read", "list", "create", "update", "delete"]
}

# Permessi per leggere policy e vederne i dettagli
path "sys/policies/acl/*" {
  capabilities = ["read", "list"]
}

# Permessi per creare secrets solo nel motore KV2
path "secret/data/*" {
  capabilities = ["create", "update"]
}

path "sys/auth" {
  capabilities = ["read", "list","create", "update"]
}

# Permessi per leggere i dettagli di uno specifico metodo di autenticazione
path "sys/auth/*" {
  capabilities = ["read"]
}

