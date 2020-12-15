#!/bin/bash
## Usage: ./camunda-deployment
##
## Options:
##    - AUTHORIZATION: which is generated with the idam-service-token.
##
## deploys bpmn/dmn to camunda.

AUTHORIZATION= sh ${WA_KUBE_ENV_PATH}/scripts/actions/idam-service-token.sh


for file in ${WA_BPMNS_DMNS_PATH}/*.bpmn ${WA_BPMNS_DMNS_PATH}/*.dmn
do
	if [ -f "$file" ]
	then
curl --header "Content-Type: multipart/form-data" "ServiceAuthorization: ${AUTHORIZATION}"\
  --request POST \
  --form data=@$file \
  "http://camunda-bpm/engine-rest/deployment/create"
  fi
done

for file in ${IA_TASK_DMNS_BPMNS_PATH}/*.bpmn ${IA_TASK_DMNS_BPMNS_PATH}/*.dmn
do
	if [ -f "$file" ]
	then
curl --header "Content-Type: multipart/form-data" "ServiceAuthorization: ${AUTHORIZATION}"\
  --request POST \
  --form data=@$file \
  "http://camunda-bpm/engine-rest/deployment/create"
  fi
done
