# Work Allocation Dev Environment

A Kubernetes environment with all the necessary services for local development using helm charts and deployed with helmfile.

## Prerequisites

- [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Helm](https://helm.sh)
- [Helmfile](https://github.com/roboll/helmfile)

These above can all bew installed via `brew install`

## Quick start

### 1. Create a local cluster:

```
  minikube start \
     --memory=8192 \
     --cpus 4 \
     --vm-driver=hyperkit
```

### 2. Start local WA environment:

  `./start.sh`

### 3. To stop local WA environment:

  `./stop.sh`


## Enabling Ingress

### 1. Enable minikube's ingress addon
  `minikube addons enable ingress`


### 2. Update /etc/hosts to route the hosts to the minikube cluster ip

```
echo "$(minikube ip) ccd-shared-database service-auth-provider-api ccd-user-profile-api shared-db idam-web-public fr-am fr-idm sidam-api ccd-definition-store-api idam-web-admin idam-web-public ccd-definition-store-api ccd-data-store-api ccd-api-gateway ccd-orchestrator wiremock xui-webapp" | sudo tee -a /etc/hosts
```

### 3. Apply Ingress chart

`kubectl apply -f ./values/ingress.yaml -n hmcts-local`


After running the above the services should be accessible via:

`http://<name-of-service>`

For example:

`http://xui-webapp`
