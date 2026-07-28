#!/usr/bin/env bash

# This file must be sourced so the variables remain in the current terminal.
_wa_db_env_is_sourced=false
if [[ -n "${BASH_VERSION:-}" && "${BASH_SOURCE[0]}" != "$0" ]]; then
  _wa_db_env_is_sourced=true
elif [[ -n "${ZSH_VERSION:-}" && "${ZSH_EVAL_CONTEXT:-}" == *:file ]]; then
  _wa_db_env_is_sourced=true
fi

if [[ "$_wa_db_env_is_sourced" != true ]]; then
  echo "Run this file with: source scripts/environment/activate-local-databases.sh" >&2
  exit 1
fi
unset _wa_db_env_is_sourced

if [[ ! -f .env ]]; then
  echo "Run this command from the wa-kube-environment repository root." >&2
  return 1
fi

if [[ ! -f .db-ports.env ]]; then
  echo ".db-ports.env does not exist. Start the database forwards first:" >&2
  echo "  make database-port-forwards-start" >&2
  return 1
fi

# The generated host-side values must override the in-cluster values in .env.
source .env
source .db-ports.env
if [[ -f .service-ports.env ]]; then
  source .service-ports.env
fi

echo "Local host environment activated:"
echo "  primary: ${POSTGRES_HOST}:${POSTGRES_PORT}"
echo "  replica: ${POSTGRES_REPLICA_HOST}:${POSTGRES_REPLICA_PORT}"
echo "  replication publisher: ${REPLICATION_SUBSCRIPTIONURL}"
