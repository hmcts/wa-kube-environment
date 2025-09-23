#!/usr/bin/env bash

# Setup Users
./create-users.sh

# Register roles
./register-roles.sh

echo ""
echo "Setup Wiremock responses for Professional Reference Data based on existing Idam users..."
./wiremock.sh

echo "Deploying camunda bpmn and dmn"
./camunda-deployment.sh

echo "Uploading CCD definitions"
./upload-ccd-definitions.sh
