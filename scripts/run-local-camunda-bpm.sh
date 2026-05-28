#!/usr/bin/env bash
set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
PROJECT_ROOT="${PROJECT_PATH:-$(cd "${REPO_ROOT}/.." && pwd)}"
CAMUNDA_BPM_REPO_PATH="${CAMUNDA_BPM_REPO_PATH:-${PROJECT_ROOT}/camunda-bpm}"

source "${REPO_ROOT}/.env"

function read_exported_value() {
  local file="$1"
  local name="$2"
  local value=""

  if [ -f "${file}" ]; then
    value="$(sed -nE "s/^[[:space:]]*export[[:space:]]+${name}=([^#]+).*$/\1/p" "${file}" | tail -n 1)"
  fi

  value="${value%\"}"
  value="${value#\"}"
  value="${value%\'}"
  value="${value#\'}"

  if [ -n "${value}" ]; then
    printf -v "${name}" '%s' "${value}"
    export "${name}"
  fi
}

read_exported_value "${HOME}/.bash_profile" "POSTGRES_PORT"
read_exported_value "${HOME}/.zprofile" "WA_CAMUNDA_NEXUS_USER"
read_exported_value "${HOME}/.zprofile" "WA_CAMUNDA_NEXUS_PASSWORD"
read_exported_value "${HOME}/.zprofile" "CAMUNDA_NEXUS_USER"
read_exported_value "${HOME}/.zprofile" "CAMUNDA_NEXUS_PASSWORD"
read_exported_value "${HOME}/.bash_profile" "WA_CAMUNDA_NEXUS_USER"
read_exported_value "${HOME}/.bash_profile" "WA_CAMUNDA_NEXUS_PASSWORD"
read_exported_value "${HOME}/.bash_profile" "CAMUNDA_NEXUS_USER"
read_exported_value "${HOME}/.bash_profile" "CAMUNDA_NEXUS_PASSWORD"

set -u

if [ -z "${POSTGRES_PORT:-}" ]; then
  echo "POSTGRES_PORT is not set. Run the environment setup and enter the ccd-shared-database port first." >&2
  exit 1
fi

echo "Using ccd-shared-database via localhost:${POSTGRES_PORT}"

if ! command -v nc > /dev/null 2>&1; then
  echo "nc was not found, skipping local database port check."
elif ! nc -z localhost "${POSTGRES_PORT}"; then
  echo "Cannot connect to ccd-shared-database via localhost:${POSTGRES_PORT}." >&2
  echo "Check the POSTGRES_PORT value from: minikube service ccd-shared-database --url -n hmcts-local" >&2
  exit 1
fi

export CAMUNDA_DB_HOST=localhost
export CAMUNDA_DB_PORT="${POSTGRES_PORT}"
export CAMUNDA_API_AUTH_ENABLED=false
export CAMUNDA_BPM_DATABASE_SCHEMA_UPDATE=true
export CAMUNDA_NEXUS_USER="${CAMUNDA_NEXUS_USER:-${WA_CAMUNDA_NEXUS_USER:-}}"
export CAMUNDA_NEXUS_PASSWORD="${CAMUNDA_NEXUS_PASSWORD:-${WA_CAMUNDA_NEXUS_PASSWORD:-}}"
export WA_AUTO_CONFIGURE_TASKS_ENABLED=false
export WA_TASK_MANAGEMENT_API_URL="${WA_TASK_MANAGEMENT_API_URL:-http://localhost:8087}"

echo "Starting camunda-bpm with CAMUNDA_DB_HOST=${CAMUNDA_DB_HOST} and CAMUNDA_DB_PORT=${CAMUNDA_DB_PORT}"
cd "${CAMUNDA_BPM_REPO_PATH}"
./gradlew bootRun
