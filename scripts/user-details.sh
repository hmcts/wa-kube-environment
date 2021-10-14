 #!/bin/bash
## Usage: ./user-details.sh [username] [password]
##
## Options:
##    - username: The username to used as login credential
##    - password: The password to used as login credential
##
## Returns user details

BASEDIR=$(dirname "$0")

USERNAME=${1:-ccd-import@fake.hmcts.net}
PASSWORD=${2:-London01}

#1. Login and obtain access token
USER_TOKEN=$($BASEDIR/actions/idam-user-token.sh $USERNAME $PASSWORD)

echo  $USER_TOKEN

#2. Get details
curl --silent --show-error -X GET "${IDAM_URL}/details" -H "accept: application/json" -H "authorization: Bearer ${USER_TOKEN}" | jq -r .
