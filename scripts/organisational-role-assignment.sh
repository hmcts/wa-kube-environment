#!/bin/bash
## Usage: ./organisational-role-assignment.sh [username] [password] [microservice_name]
##
## Options:
##    - username: Role assigned to user in generated token. Default to `ccd-import@fake.hmcts.net`.
##    - password: Password for user. Default to `London01`.
##    - microservice_name: Name of the microservice. Default to `ccd_gw`.
##
## Returns a valid IDAM service token for the given microservice.

USERNAME=${1:-ccd-import@fake.hmcts.net}
PASSWORD=${2:-London01}
MICROSERVICE="${3:-ccd_gw}"

USER_TOKEN=`./idam-user-token.sh $USERNAME $PASSWORD`
USER_ID=`./idam-user-id.sh $USER_TOKEN`
SERVICE_TOKEN=`./idam-service-token.sh $MICROSERVICE`

curl -X POST "${ROLE_ASSIGNMENT_URL}/am/role-assignments" \
    -H "accept: application/vnd.uk.gov.hmcts.role-assignment-service.create-assignments+json;charset=UTF-8;version=1.0" \
    -H "Authorization: Bearer ${USER_TOKEN}" \
    -H "ServiceAuthorization: Bearer ${SERVICE_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{ \"roleRequest\": { \"assignerId\": \"${USER_ID}\", \"process\": \"staff-organisational-role-mapping\", \"reference\": \"${USER_ID}\", \"replaceExisting\": true }, \"requestedRoles\": [ { \"actorIdType\": \"IDAM\", \"actorId\": \"${USER_ID}\", \"roleType\": \"ORGANISATION\", \"roleName\": \"tribunal-caseworker\", \"roleCategory\": \"STAFF\", \"classification\": \"PUBLIC\", \"grantType\": \"STANDARD\", \"readOnly\": false, \"attributes\": { \"jurisdiction\": \"IA\", \"primaryLocation\": \"123456\" } } ]}"
