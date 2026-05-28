#!/usr/bin/env bash

NAMESPACE="hmcts-local"
SECRET_NAME="hmcts-private-creds"

echo "💣  Deleting ACR token"
kubectl delete secret $SECRET_NAME -n $NAMESPACE

echo "💣  Stopping and removing all containers"
helmfile -n $NAMESPACE destroy

echo "💣  Removing legacy camunda-bpm pod deployment if present"
helm uninstall camunda-local-bpm -n $NAMESPACE --ignore-not-found || true
kubectl delete deployment camunda-local-bpm service camunda-local-bpm -n $NAMESPACE --ignore-not-found=true || true
