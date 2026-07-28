#!/usr/bin/env bash

set -euo pipefail

NAMESPACE="${KUBE_NAMESPACE:-hmcts-local}"
REQUIRED_SERVICES=(
  ccd-shared-database
  ccd-shared-database-replica
  wiremock
  ccd-definition-store-api
  sidam-simulator
  service-auth-provider-api
  ccd-api-gateway
  am-role-assignment
  camunda-local-bpm
  ccd-data-store-api
)

if ! kubectl cluster-info >/dev/null 2>&1; then
  echo "Kubernetes is not reachable." >&2
  exit 1
fi

ready=true
for service in "${REQUIRED_SERVICES[@]}"; do
  addresses="$(kubectl -n "$NAMESPACE" get endpoints "$service" \
    -o jsonpath='{.subsets[*].addresses[*].ip}' 2>/dev/null || true)"
  if [[ -z "$addresses" ]]; then
    echo "Waiting for required service: ${NAMESPACE}/${service}" >&2
    ready=false
  fi
done

[[ "$ready" == true ]]
