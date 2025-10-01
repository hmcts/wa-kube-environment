#!/usr/bin/env bash

ID="${1:-ccd-import}"

BASEDIR=$(dirname "$0")
apiToken=$($BASEDIR/authenticate.sh "${IDAM_URL}" "${WA_SYSTEM_USERNAME}" "${WA_SYSTEM_PASSWORD}")

echo "\nCreating role with:\nName: ${ID}\n"

curl --silent --show-error ${IDAM_URL}/roles \
  -H 'Content-Type: application/json' \
  -H "Authorization: AdminApiAuthToken ${apiToken}" \
  -d '{
        "assignableRoles": [],
        "conflictingRoles": [],
        "description": "'"${ID}"'",
        "id": "'"${ID}"'",
        "linkedRoles": [],
        "name": "'"${ID}"'"
      }'

echo ""
