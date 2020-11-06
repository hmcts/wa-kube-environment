#!/bin/sh

LABEL="${1:-ccd_gateway}"
SELF_REG="${2:-false}"
CLIENT_ID="${3:-ccd_gateway}"
CLIENT_SECRET="${4:-OOOOOOOOOOOOOOOO}"
REDIRECT_URLS="${5:-[\"http://localhost:3451/oauth2redirect\"]}"
ALLOWED_ROLES="${6:-[\"caseworker\", \"caseworker-ia\"]}"
DESCRIPTION="${7:-CCD Gateway}"
SCOPE="${8:-openid profile roles}"

BASEDIR=$(dirname "$0")
apiToken=$($BASEDIR/authenticate.sh "${IDAM_URL}" "${IDAM_ADMIN_USER}" "${IDAM_ADMIN_PASSWORD}")

echo "\nCreating service with:\nLabel: ${LABEL}\nClient ID: ${CLIENT_ID}\nClient Secret: ${CLIENT_SECRET}\nRedirect URL: ${REDIRECT_URLS}\nRoles: ${ALLOWED_ROLES}\n"

curl --silent --show-error ${IDAM_URL}/services \
  -H 'Content-Type: application/json' \
  -H "Authorization: AdminApiAuthToken ${apiToken}" \
  -d '{
         "allowedRoles": '"${ALLOWED_ROLES}"',
         "description": "'"${DESCRIPTION}"'",
         "label": "'"${LABEL}"'",
         "oauth2ClientId": "'"${CLIENT_ID}"'",
         "oauth2ClientSecret": "'"${CLIENT_SECRET}"'",
         "oauth2RedirectUris": '"${REDIRECT_URLS}"',
         "oauth2Scope": "'"${SCOPE}"'",
         "selfRegistrationAllowed": '"${SELF_REG}"'
       }'
