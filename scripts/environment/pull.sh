#!/bin/sh

EXTERNAL_IMAGES=(
  bitnami/postgresql
  rodolpheche/wiremock
  mcr.microsoft.com/azure-storage/azurite
)

PUBLIC_IMAGES=(
  hmctspublic.azurecr.io/am/role-assignment-service:latest
  hmctspublic.azurecr.io/rpe/service-auth-provider:latest
  hmctspublic.azurecr.io/idam/web-admin:stable
  hmctspublic.azurecr.io/ccd/user-profile-api:latest
  hmctspublic.azurecr.io/ccd/message-publisher:latest
  hmctspublic.azurecr.io/ccd/definition-store-api:latest
  hmctspublic.azurecr.io/ccd/data-store-api:latest
  hmctspublic.azurecr.io/ccd/api-gateway-web:latest
  hmctspublic.azurecr.io/ccd/case-management-web:latest
  hmctspublic.azurecr.io/ccd/case-document-am-api
  hmctspublic.azurecr.io/em/ccd-orchestrator:latest
  hmctspublic.azurecr.io/xui/webapp:latest
  hmctspublic.azurecr.io/hmcts/rse/rse-idam-simulator:latest
  hmctspublic.azurecr.io/dm/store:latest
)

PRIVATE_IMAGES=(
  hmctsprivate.azurecr.io/camunda/bpm:latest
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
