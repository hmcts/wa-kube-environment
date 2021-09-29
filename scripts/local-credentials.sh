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
USER_RESPONSE=$($BASEDIR/user-details.sh "${TEST_WA_CASEOFFICER_PUBLIC_A_USERNAME}" "${TEST_WA_CASEOFFICER_PUBLIC_A_PASSWORD}")

S2S_TOKEN=$($BASEDIR/actions/idam-service-token.sh "wa_task_management_api")

echo  $USER_RESPONSE
echo  "s2s token:" $S2S_TOKEN
