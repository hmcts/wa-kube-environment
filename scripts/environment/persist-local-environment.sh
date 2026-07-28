#!/usr/bin/env bash

set -euo pipefail

KUBE_ENV_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SHELL_PROFILE="${WA_SHELL_PROFILE:-${HOME}/.bash_profile}"
BEGIN_MARKER="# BEGIN wa-kube-environment no-admin"
END_MARKER="# END wa-kube-environment no-admin"

cd "$KUBE_ENV_DIR"

for environment_file in .db-ports.env .service-ports.env; do
  if [[ ! -f "$environment_file" ]]; then
    echo "${environment_file} does not exist. Start the port forwards first." >&2
    exit 1
  fi
done

# shellcheck disable=SC1091
source .db-ports.env
# shellcheck disable=SC1091
source .service-ports.env

if [[ -e "$SHELL_PROFILE" && ! -w "$SHELL_PROFILE" ]]; then
  echo "Cannot update ${SHELL_PROFILE} because it is not writable." >&2
  exit 1
fi

profile_directory="$(dirname "$SHELL_PROFILE")"
mkdir -p "$profile_directory"
temporary_profile="$(mktemp "${TMPDIR:-/tmp}/wa-shell-profile.XXXXXX")"
trap 'rm -f "$temporary_profile"' EXIT

if [[ -f "$SHELL_PROFILE" ]]; then
  awk -v begin="$BEGIN_MARKER" -v end="$END_MARKER" '
    $0 == begin { managed = 1; next }
    $0 == end { managed = 0; next }
    !managed { print }
  ' "$SHELL_PROFILE" >"$temporary_profile"
fi

{
  echo
  echo "$BEGIN_MARKER"
  for variable_name in \
    POSTGRES_HOST \
    POSTGRES_CLUSTER_HOST \
    POSTGRES_REPLICA_HOST \
    POSTGRES_PORT \
    POSTGRES_REPLICA_PORT \
    REPLICATION_SUBSCRIPTIONURL \
    WIREMOCK_URL \
    CCD_SEARCH_URL \
    CCD_DEFINITION_STORE \
    CCD_DEFINITION_URL \
    IDAM_URL \
    IDAM_API_URL \
    IDAM_API_BASE_URI \
    IDAM_STUB_LOCALHOST \
    OPEN_ID_IDAM_URL \
    S2S_URL \
    CCD_GW_URL \
    ROLE_ASSIGNMENT_URL \
    CAMUNDA_URL \
    CCD_URL; do
    printf 'export %s=%q\n' "$variable_name" "${!variable_name}"
  done
  echo "$END_MARKER"
} >>"$temporary_profile"

if [[ -f "$SHELL_PROFILE" ]]; then
  chmod "$(stat -f '%Lp' "$SHELL_PROFILE")" "$temporary_profile"
fi
mv "$temporary_profile" "$SHELL_PROFILE"
trap - EXIT

echo "Updated ${SHELL_PROFILE} with the no-admin localhost settings."
echo "New terminals and a restarted IntelliJ will load these values automatically."
