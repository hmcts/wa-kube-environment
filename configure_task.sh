#!/bin/bash
## Usage: ./camunda-deployment [SERVICE_TOKEN]
##
## Options:
##    - SERVICE_TOKEN: a service token for a whitelisted service in camunda which is generated with the idam-service-token.
##    -  TASK_MANAGEMENT: env url
##    -  TASK_CONFIG: env url

microservice="${1:-wa_task_configuration_api}"
taskManagement="${2:-http://camunda-api-aat.service.core-compute-aat.internal/engine-rest/task}"
taskConfig="${3:-http://wa-task-configuration-api-aat.service.core-compute-aat.internal/task}"

serviceToken=$(curl --silent --show-error -X POST \
  -H "Content-Type: application/json" \
  -d '{"microservice":"'${microservice}'"}' \
  ${S2S_URL}/o/token
)

# GET TASKS
response=$(curl --request POST \
  --url "${taskManagement}" \
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
  --url "${taskConfig}/${ID_RESPONSE}" \
  --header 'Authorization: Basic Og==' \
  --header 'Content-Type: application/json' \
  --header "ServiceAuthorization: Bearer ${serviceToken}" \
)
done

# DELETE FILE FROM TEMP AFTER
rm "$tmpfile"

