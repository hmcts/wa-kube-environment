# Work Allocation Dev Environment

A Kubernetes environment with all the necessary services for local development using helm charts and deployed with helmfile.

## Prerequisites

- [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [azure-cli](https://docs.microsoft.com/en-gb/cli/azure/install-azure-cli)
- [docker](https://www.docker.com/)
- [Helm](https://helm.sh)
- [Helmfile](https://github.com/roboll/helmfile)

The above can all brew installed via `brew install`

## Quick start


### 0. Create a local cluster:

```
minikube start \
     --memory=12288 \
     --cpus=4 \
     --vm-driver=hyperkit \
     --addons=ingress
```

### 1. Environment variables

Source the .env file in the root of the project:
```
  source .env
```
Set the following environment variables on your `.bash_profile`

```
export WA_CAMUNDA_NEXUS_PASSWORD=XXXXXX
export WA_CAMUNDA_NEXUS_USER=XXXXXX
```
**Note:** _the values for the above environment variables can be found on this [Confluence Page](https://tools.hmcts.net/confluence/display/WA/Camunda+Enterprise+Licence+Key)_

### 2. Login:

  `./environment login`

### 3. Pre-pulling (Recommended but optional):
*Note: this step could take a while to complete as it pull all the necessary images*
  `./environment pull`

### 4. Build and start local WA environment:

  `./environment up`

### 5. To stop and teardown local WA environment:

  `./environment down`


## Enabling Ingress hosts

### 1. Update /etc/hosts to route the hosts to the minikube cluster ip

```
echo "$(minikube ip) ccd-shared-database service-auth-provider-api ccd-user-profile-api shared-db idam-web-public fr-am fr-idm sidam-api ccd-definition-store-api idam-web-admin idam-web-public ccd-definition-store-api ccd-data-store-api ccd-api-gateway wiremock xui-webapp ccd-case-management-web camunda-bpm" | sudo tee -a /etc/hosts
```

After running the above the services should be accessible via:

`http://<name-of-service>`

For example:

`http://xui-webapp`


## Verifying deployments

We can verify the deployments were successful listing all pods under our namespace

 `kubectl get pods -n hmcts-local`

The output should look like below:

```
❯  kubectl get pods -n hmcts-local                                                                                10:57:13
NAME                                         READY   STATUS    RESTARTS   AGE
ccd-api-gateway-7f658885b9-gjg59             1/1     Running   0          2m5s
ccd-case-management-web-7bc9987747-4fzhw     1/1     Running   0          114s
ccd-data-store-api-7678c9c4cc-z8bwf          1/1     Running   0          2m40s
ccd-definition-store-api-74b455764b-zdbgj    1/1     Running   0          3m48s
ccd-orchestrator-65ffd6747c-s9w77            1/1     Running   0          101s
ccd-shared-database-0                        1/1     Running   0          6m46s
ccd-user-profile-api-749dd8d668-4b8cd        1/1     Running   0          5m49s
fr-am-6b69cb5f95-2tlz4                       1/1     Running   0          5m25s
fr-idm-575d89f957-fb6rl                      1/1     Running   0          5m22s
idam-web-admin-957474868-l62q6               1/1     Running   0          4m34s
idam-web-public-c8cf99759-s86g4              1/1     Running   0          4m15s
service-auth-provider-api-5744c5f89b-9rtm5   1/1     Running   0          6m2s
shared-db-76d8954d5c-24t2g                   1/1     Running   0          5m28s
sidam-api-59b66bf4cb-d24j6                   1/1     Running   0          5m19s
wiremock-59669584fc-xcxjw                    1/1     Running   0          74s
xui-webapp-7485d8c499-htmq5                  1/1     Running   0          71s
```
