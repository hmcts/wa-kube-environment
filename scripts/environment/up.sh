#!/bin/sh

NAMESPACE="hmcts-local"
SECRET_NAME="hmcts-private-creds"

echo "ℹ️  Setting up Local development environment"
echo "↪️️  Creating $NAMESPACE namespace"
#This might error if namespace already exist, but will not stop the script.
kubectl create namespace $NAMESPACE

echo "↪️  Creating persistent volume"
kubectl apply -f ./charts/pv.yaml -n hmcts-local
echo "↪️  Creating persistent volume claim"
kubectl apply -f ./charts/pvc.yaml -n hmcts-local

echo "↪️  Applying ingress config"
kubectl apply -f ./ingress/ingress.yaml -n hmcts-local
kubectl patch configmap tcp-services -n kube-system --patch '{"data":{"5432":"hmcts-local/ccd-shared-database:5432"}}'
kubectl patch deployment ingress-nginx-controller --patch "$(cat ./ingress/ingress-patch.yaml)" -n kube-system

echo "↪️  Obtaining ACR token"
TOKEN=$(az acr login --name hmctsprivate --subscription DCD-CNP-PROD --expose-token | jq --raw-output '.accessToken')

echo "↪️  Saving Token as secret"
kubectl create secret docker-registry $SECRET_NAME \
  --docker-server=hmctsprivate.azurecr.io \
  --docker-username=00000000-0000-0000-0000-000000000000 \
  --docker-password=$TOKEN \
  -n $NAMESPACE

echo "↪️  Starting deployments"
helmfile -n hmcts-local sync
