#!/usr/bin/env bash

EXTERNAL_IMAGES=(
  bitnami/postgresql
  rodolpheche/wiremock
  mcr.microsoft.com/azure-storage/azurite
)

PUBLIC_IMAGES=(
  hmctsprod.azurecr.io/am/role-assignment-service:latest
  hmctsprod.azurecr.io/rpe/service-auth-provider:latest
  hmctsprod.azurecr.io/idam/web-admin:stable
  hmctsprod.azurecr.io/ccd/user-profile-api:latest
  hmctsprod.azurecr.io/ccd/message-publisher:latest
  hmctsprod.azurecr.io/ccd/definition-store-api:latest
  hmctsprod.azurecr.io/ccd/data-store-api:latest
  hmctsprod.azurecr.io/ccd/api-gateway-web:latest
  hmctsprod.azurecr.io/ccd/case-document-am-api
  hmctsprod.azurecr.io/xui/webapp:latest
  hmctsprod.azurecr.io/hmcts/rse/rse-idam-simulator:latest
)

PRIVATE_IMAGES=(
  hmctsprod.azurecr.io/camunda/bpm:latest
)

## Usage: pull_image [type] [image_repository]
##
##Helper function to perform image pulls
## Options:
##    - type: Type of repository used for a descriptive message only [external/public/private]
##    - image_repository: The location where the image to pull is hosted
##
 function pull_image {
   echo "⬇️  Attempting to pull $1 image from $2"

   if docker pull $2 --quiet > /dev/null ; then
     echo "✅  $2 pulled successfully"
   else
     echo "❌  Something went wrong when pulling image from $2 "
   fi
   }

echo "ℹ️  Pulling images to kubernetes cluster"

echo "🛠️  Configuring environment to use minikube's Docker daemon"
eval $(minikube docker-env)

echo "↪️  Pulling external public images"
for repo in "${EXTERNAL_IMAGES[@]}"; do
  pull_image "external" $repo
done

echo "↪️  Pulling HMCTS public images"
for repo in "${PUBLIC_IMAGES[@]}"; do
  pull_image "HMCTS public" $repo
done

echo "↪️  Pulling HMCTS private images"
for repo in "${PRIVATE_IMAGES[@]}"; do
    pull_image "HMCTS private" $repo
done
