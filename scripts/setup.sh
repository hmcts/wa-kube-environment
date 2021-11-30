#!/usr/bin/env bash

scriptsFolder=$(dirname "${0}")

# Setup Services
#./create-services.sh

# Setup Roles
#./create-roles.sh

# Setup Users
"${scriptsFolder}/create-users.sh"

# Register roles
"${scriptsFolder}/register-roles.sh"

echo ""
echo "Setup Wiremock responses for Professional Reference Data based on existing Idam users..."
"${scriptsFolder}/wiremock.sh"

echo "Deploying camunda bpmn and dmn"
"${scriptsFolder}/camunda-deployment.sh"
