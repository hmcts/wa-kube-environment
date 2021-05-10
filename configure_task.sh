#!/bin/bash
## Usage: ./camunda-deployment [SERVICE_TOKEN]
##
## Options:
##    - SERVICE_TOKEN: a service token for a whitelisted service in camunda which is generated with the idam-service-token.
##    -  TASK_MANAGEMENT: env url
##    -  TASK_CONFIG: env url

microservice="${1:-wa_task_configuration_api}"
CAMUNDA_URL="${2:-http://camunda-api-aat.service.core-compute-aat.internal/engine-rest/task}"
WA_TASK_CONFIGURATION_URL="${3:-http://wa-task-configuration-api-aat.service.core-compute-aat.internal/task}"


serviceToken=$(curl --request POST \
  --url https://idam-web-public.prod.platform.hmcts.net/o/token \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --data client_secret=NDPH6DFQBIPA9UP7 \
  --data client_id=iac \
  --data redirect_uri=https://ia-case-api-prod.service.core-compute-prod.internal/oauth2/callback \
  --data password=System01 \
  --data grant_type=password \
  --data username=wa-system-user@hmcts.net \
  --data 'scope=openid profile roles'
)


# GET TASKS
response=$(curl --request POST \
  --url "${CAMUNDA_URL}" \
  --header 'Content-Type: application/json' \
  --data "{
    'orQueries': [
        {
            'processVariables': [
                {
                    'name': 'taskState',
                    'operator': 'eq',
                    'value': 'unconfigured'
                }
            ]
        }
    ],
    'createdAfter': ${date +'%Y-%m-%dT%H:%M:%S.000%z'},
    'taskDefinitionKey': 'processTask',
    'processDefinitionKey': 'wa-task-initiation-ia-asylum'
}")

# CREATE FILE WITH TASKS WITH NUMBER OF TASKS
tmpfile=$(mktemp /tmp/tasks.json)
echo ${response} > /tmp/tasks.json


# LOOP OVER ALL IDS
for ID in $(seq 0 $(jq length /tmp/tasks.json)); do
ID_RESPONSE=$(cat /tmp/tasks.json | jq -r ".[${ID}].id")
response=$(curl --request POST \
  --url "${WA_TASK_CONFIGURATION_URL}/${ID_RESPONSE}" \
  --header 'Authorization: Basic Og==' \
  --header 'Content-Type: application/json' \
  --header "ServiceAuthorization: Bearer ${serviceToken}" \
)
done

# DELETE FILE FROM TEMP AFTER
rm "$tmpfile"

