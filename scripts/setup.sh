#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

if [ -f "${REPO_ROOT}/.env" ]; then
  source "${REPO_ROOT}/.env"
fi

cd "${SCRIPT_DIR}"

# Setup Users
./create-users.sh

# Register roles
./register-roles.sh

echo ""
echo "Setup Wiremock responses for Professional Reference Data based on existing Idam users..."
./wiremock.sh

echo "Deploying camunda bpmn and dmn"
./camunda-deployment.sh
