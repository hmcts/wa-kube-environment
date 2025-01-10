#!/usr/bin/env bash

echo "ℹ️  Patching Ingress"
echo "↪️️  Switching context to minikube"
#Switch to local cluster to avoid attempting to deploy in other clusters
kubectl config use-context minikube

echo "↪️  Applying ingress config"
kubectl apply -f ./ingress/ingress.yaml -n hmcts-local
kubectl patch configmap tcp-services -n ingress-nginx --patch '{"data":{"'"${POSTGRES_PORT}"'":"hmcts-local/ccd-shared-database:5432"}}'
kubectl patch configmap tcp-services -n ingress-nginx --patch '{"data":{"'"${POSTGRES_REPLICA_PORT}"'":"hmcts-local/ccd-shared-database-replica:5432"}}'
kubectl patch deployment ingress-nginx-controller --patch "spec:
                                                             strategy:
                                                               rollingUpdate:
                                                                 maxUnavailable: 1
                                                               type: RollingUpdate
                                                             template:
                                                               spec:
                                                                 containers:
                                                                   - name: controller
                                                                     ports:
                                                                       - containerPort: 5432
                                                                         hostPort: 5432
                                                                       - containerPort: 5433
                                                                         hostPort: 5433
                                                                       - containerPort: ${POSTGRES_PORT}
                                                                         hostPort: ${POSTGRES_PORT}
                                                                       - containerPort: ${POSTGRES_REPLICA_PORT}
                                                                         hostPort: ${POSTGRES_REPLICA_PORT}
                                                                         " -n ingress-nginx