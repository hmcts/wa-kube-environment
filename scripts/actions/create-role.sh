#!/bin/sh

ID="${1:-ccd-import}"

BASEDIR=$(dirname "$0")
apiToken=$($BASEDIR/authenticate.sh "${IDAM_URL}" "${IDAM_ADMIN_USER}" "${IDAM_ADMIN_PASSWORD}")

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
