#!/usr/bin/env bash

set -euo pipefail

KUBE_ENV_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DEFINITIONS_DIR="${WA_CCD_DEFINITIONS_DIR:-$(cd "${KUBE_ENV_DIR}/.." && pwd)/wa-ccd-definitions}"

if [[ ! -d "$DEFINITIONS_DIR" ]]; then
  echo "Cannot find wa-ccd-definitions at ${DEFINITIONS_DIR}." >&2
  exit 1
fi

cd "$KUBE_ENV_DIR"
source scripts/environment/activate-local-databases.sh

echo "Generating WA CCD definitions..."
cd "$DEFINITIONS_DIR"
yarn generate-dev

echo "Obtaining IDAM and S2S tokens..."
USER_TOKEN="$("${KUBE_ENV_DIR}/scripts/actions/idam-user-token.sh")"
SERVICE_TOKEN="$("${KUBE_ENV_DIR}/scripts/actions/idam-service-token.sh")"
if [[ -z "$USER_TOKEN" || -z "$SERVICE_TOKEN" ]]; then
  echo "Could not obtain the IDAM or S2S token." >&2
  exit 1
fi

echo "Uploading WA CCD definitions through ${CCD_DEFINITION_STORE}..."
curl --fail-with-body --show-error \
  "${CCD_DEFINITION_STORE}/import" \
  -H "Authorization: Bearer ${USER_TOKEN}" \
  -H "ServiceAuthorization: Bearer ${SERVICE_TOKEN}" \
  -F "file=@target/appeal/xlsx/ccd-appeal-config-dev.xlsx"
echo
