#!/bin/sh

NAMESPACE="hmcts-local"
SECRET_NAME="hmcts-private-creds"

echo "Setting up Local development environment"
echo "-> Creating $NAMESPACE namespace"
#This might error if namespace already exist, but will not stop the script.
kubectl create namespace $NAMESPACE

echo "-> Obtaining ACR token"
TOKEN=$(az acr login --name hmctsprivate --subscription DCD-CNP-PROD --expose-token | jq --raw-output '.accessToken')

echo "-> Saving Token as secret"
kubectl create secret docker-registry $SECRET_NAME \
  --docker-server=hmctsprivate.azurecr.io \
  --docker-username=00000000-0000-0000-0000-000000000000 \
  --docker-password=$TOKEN \
  -n $NAMESPACE

echo "-> Starting deployments"
helmfile -n hmcts-local sync
