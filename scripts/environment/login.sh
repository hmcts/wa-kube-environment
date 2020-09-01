#!/bin/sh

echo "-> Performing Login"
TOKEN=$(az acr login --name hmctsprivate --subscription DCD-CNP-PROD --expose-token | jq --raw-output '.accessToken')
docker login hmctsprivate.azurecr.io \
  --username=00000000-0000-0000-0000-000000000000 \
  --password=$TOKEN
