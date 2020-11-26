#!/bin/sh


NAMESPACE="hmcts-local"
SECRET_NAME="hmcts-private-creds"

echo "Setting up Local development environment"
echo "-> Creating $NAMESPACE namespace"
#This might error if namespace already exist, but will not stop the script.
kubectl create namespace $NAMESPACE

echo "-> Creating persistent volume"
kubectl apply -f ./charts/pv.yaml -n hmcts-local
echo "-> Creating persistent volume claim"
kubectl apply -f ./charts/pvc.yaml -n hmcts-local

echo "-> Applying ingress config"
kubectl apply -f ./ingress/ingress.yaml
kubectl patch configmap tcp-services -n kube-system --patch '{"data":{"5432":"hmcts-local/ccd-shared-database:5432"}}'
kubectl patch deployment ingress-nginx-controller --patch "$(cat ./ingress/ingress-patch.yaml)" -n kube-system

echo "-> Obtaining ACR token"
TOKEN=$(az acr login --name hmctsprivate --subscription DCD-CNP-PROD --expose-token | jq --raw-output '.accessToken')

echo "-> Saving Token as secret"
kubectl create secret docker-registry $SECRET_NAME \
  --docker-server=hmctsprivate.azurecr.io \
  --docker-username=00000000-0000-0000-0000-000000000000 \
  --docker-password=$TOKEN \
  -n $NAMESPACE

echo "-> Starting deployments"
helmfile sync

echo "-> Setting up monitoring"

$MONITORING_NAMESPACE="monitoring"
echo "-> Creating $MONITORING_NAMESPACE namespace"
#This might error if namespace already exist, but will not stop the script.
kubectl create namespace $MONITORING_NAMESPACE

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://charts.helm.sh/stable
helm repo update

helm install $MONITORING_NAMESPACE prometheus-community/kube-prometheus-stack -n $MONITORING_NAMESPACE

echo "-> Applying monitoring ingress config"
kubectl apply -f ./ingress/ingress-monitoring.yaml
