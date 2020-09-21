#!/bin/sh

EXTERNAL_IMAGES=(
  bitnami/postgresql
  rodolpheche/wiremock
)

PUBLIC_IMAGES=(
  hmctspublic.azurecr.io/rpe/service-auth-provider:latest
  hmctspublic.azurecr.io/ccd/user-profile-api:latest
  hmctspublic.azurecr.io/idam/api:stable
  hmctspublic.azurecr.io/idam/web-admin:stable
  hmctspublic.azurecr.io/idam/web-public:stable
  hmctspublic.azurecr.io/ccd/definition-store-api:latest
  hmctspublic.azurecr.io/ccd/data-store-api:latest
  hmctspublic.azurecr.io/ccd/api-gateway-web:latest
  hmctspublic.azurecr.io/ccd/case-management-web:latest
  hmctspublic.azurecr.io/em/ccd-orchestrator:latest
  hmctspublic.azurecr.io/xui/webapp:prod-e69c0d43
)

PRIVATE_IMAGES=(
  hmctsprivate.azurecr.io/idam/shared-db:latest
  hmctsprivate.azurecr.io/idam/idam-fr-am:latest
  hmctsprivate.azurecr.io/idam/idam-fr-idm:latest
  hmctsprivate.azurecr.io/camunda/bpm:latest
)

echo "Pulling images to kubernetes cluster"

echo "-> Configuring environment to use minikube's Docker daemon"
eval $(minikube docker-env)

echo "-> Pulling external public images"
for repo in "${EXTERNAL_IMAGES[@]}"; do
  docker pull $repo --quiet
done

echo "-> Pulling HMCTS public images"
for repo in "${PUBLIC_IMAGES[@]}"; do
  docker pull $repo --quiet
done

echo "-> Pulling HMCTS private images"
for repo in "${PRIVATE_IMAGES[@]}"; do
  docker pull $repo --quiet
done
