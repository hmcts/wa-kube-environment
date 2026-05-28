#!/usr/bin/env bash
## Usage: ./camunda-deployment
##
## Options:
##    - SERVICE_TOKEN: which is generated with the idam-service-token.
##
## deploys bpmn/dmn to camunda.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

if [ -f "${REPO_ROOT}/.env" ]; then
  source "${REPO_ROOT}/.env"
fi

set -euo pipefail

CAMUNDA_DEPLOYMENT_WAIT_SECONDS="${CAMUNDA_DEPLOYMENT_WAIT_SECONDS:-180}"
CAMUNDA_DEPLOYMENT_POLL_SECONDS="${CAMUNDA_DEPLOYMENT_POLL_SECONDS:-5}"
DEPLOY_WA_BPMNS=false
DEPLOY_WA_TASK_DMNS=false

function wait_for_camunda() {
  local timeout_at=$((SECONDS + CAMUNDA_DEPLOYMENT_WAIT_SECONDS))

  echo "Waiting for Camunda at ${CAMUNDA_URL}..."
  until curl --silent --show-error --fail --max-time 5 "${CAMUNDA_URL}/version" > /dev/null; do
    if [ "${SECONDS}" -ge "${timeout_at}" ]; then
      echo "Camunda was not ready at ${CAMUNDA_URL}/version after ${CAMUNDA_DEPLOYMENT_WAIT_SECONDS}s" >&2
      exit 1
    fi

    sleep "${CAMUNDA_DEPLOYMENT_POLL_SECONDS}"
  done
}

echo "Uploading Camunda BPMs and DMNs..."
if [[ -z "${WA_BPMNS_DMNS_PATH:-}" ]]; then
  echo "Environment variable WA_BPMNS_DMNS_PATH was not set skipping deployment."
else
  if [ ! -x "${WA_BPMNS_DMNS_PATH}/camunda-deployment.sh" ]; then
    echo "Expected deployment script was not found: ${WA_BPMNS_DMNS_PATH}/camunda-deployment.sh" >&2
    exit 1
  fi
  DEPLOY_WA_BPMNS=true
fi

if [[ -z "${WA_TASK_DMNS_BPMNS_PATH:-}" ]]; then
  echo ""
  echo "Environment variable WA_TASK_DMNS_BPMNS_PATH was not set skipping deployment."
else
  if [ ! -x "${WA_TASK_DMNS_BPMNS_PATH}/camunda-deployment.sh" ]; then
    echo "Expected deployment script was not found: ${WA_TASK_DMNS_BPMNS_PATH}/camunda-deployment.sh" >&2
    exit 1
  fi
  DEPLOY_WA_TASK_DMNS=true
fi

if [ "${DEPLOY_WA_BPMNS}" = "false" ] && [ "${DEPLOY_WA_TASK_DMNS}" = "false" ]; then
  echo "No Camunda BPMN/DMN artifact paths were configured."
  exit 0
fi

: "${CAMUNDA_URL:?CAMUNDA_URL must be set before deploying Camunda BPMNs/DMNs.}"
: "${S2S_URL:?S2S_URL must be set before requesting the Camunda upload service token.}"

wait_for_camunda

SERVICE_TOKEN="$(sh "${SCRIPT_DIR}/actions/idam-service-token.sh" "wa_camunda_pipeline_upload")"
if [ -z "${SERVICE_TOKEN}" ]; then
  echo "Could not obtain a service token for wa_camunda_pipeline_upload." >&2
  exit 1
fi

if [ "${DEPLOY_WA_BPMNS}" = "true" ]; then
  echo "Deploying WA Standalone Task BPMN and DMNs"
  "${WA_BPMNS_DMNS_PATH}/camunda-deployment.sh" "${SERVICE_TOKEN}"
fi

if [ "${DEPLOY_WA_TASK_DMNS}" = "true" ]; then
  echo ""
  echo ""
  echo "Deploying WA Task Configuration BPMN and DMNs..."
  "${WA_TASK_DMNS_BPMNS_PATH}/camunda-deployment.sh" "${SERVICE_TOKEN}"
fi
