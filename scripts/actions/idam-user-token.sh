#!/usr/bin/env bash
## Usage: ./idam-user-token.sh [user] [password]
##
## Options:
##    - username: Role assigned to user in generated token. Default to `ccd-import@fake.hmcts.net`.
##    - password: ID assigned to user in generated token. Default to `London01`.
##

USERNAME=${1:-ccd-import@fake.hmcts.net}
PASSWORD=${2:-London01}
REDIRECT_URI="http://xui-webapp/oauth2/callback"
CLIENT_ID="ccd_gateway"
CLIENT_SECRET="OOOOOOOOOOOOOOOO"
SCOPE="openid%20profile%20roles%20authorities"

curl --silent --show-error \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -X POST "${IDAM_URL}/o/token?grant_type=password&redirect_uri=${REDIRECT_URI}&client_id=${CLIENT_ID}&client_secret=${CLIENT_SECRET}&username=${USERNAME}&password=${PASSWORD}&scope=${SCOPE}" -d "" | jq -r .access_token
