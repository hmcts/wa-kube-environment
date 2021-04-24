# Work Allocation Dev Environment

A Kubernetes environment with all the necessary services for local development using helm charts and deployed with
helmfile.

## Prerequisites

- HMCTS account
- Github access to public and private repositories. Need to have a Jira ticket (Reporting Mgr/Tech Lead will handle)
  Once the ticket got assigned, DevOps team will ask for user acceptance which can be done on this page
  https://tools.hmcts.net/confluence/display/RPE/Acceptable+Use+Policy+and+Contractor+Security+Guidance
- Access to Azure and container registry, clone https://github.com/hmcts/devops-azure-ad
  If you can't access it, then you do not have access to private repositories(Goto previous step) and check with Devops
  team. If you can access, then create a branch something like 'adding-permissions-your-name'.

Modify file /users/prod_users.yml by adding permissions to the EOF. Check with the team which permissions need to be
included.

Create a pull request and assign to a reviewer from the team and get approved. Post the pull request in slack channel
HMCTS Reform #devops request channel to authorise your pull request. Once it is approved a pipeline will be triggered
automatically.

- [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [azure-cli](https://docs.microsoft.com/en-gb/cli/azure/install-azure-cli)
  After installation, check if you can access Azure, by ```az login``` in your terminal. Page will open in your browser
  where you are prompted to log in to Microsoft using your hmcts email account. Click and log in. On your terminal you
  should see a list of accounts which have got permission. You can also type ```az account list``` to get the list of
  accounts you are subscribed to.
- [docker](https://www.docker.com/)
- [Helm](https://helm.sh)
- [Helmfile](https://github.com/roboll/helmfile)

The above can all brew installed via `brew install`

## Quick start

### 1. Create a local cluster:

If you are using minikube version v1.15.1 or later

```shell
minikube start \
     --memory=12288 \
     --cpus=4 \
     --driver=hyperkit \
     --addons=ingress
```

for older versions

```shell
minikube start \
     --memory=8192 \
     --cpus=4 \
     --vm-driver=hyperkit \
     --addons=ingress
```

### 2. Environment variables

Source the .env file in the root of the project:

```shell
source .env
```

Set the following environment variables on your `.bash_profile`
and make sure the terminal can read `.bash_profile`

```
export WA_CAMUNDA_NEXUS_PASSWORD=XXXXXX
export WA_CAMUNDA_NEXUS_USER=XXXXXX
export AM_ROLE_SERVICE_SDK_KEY=XXXXX
export WA_BPMNS_DMNS_PATH=<PATH_TO_BPMN_REPO>
export IA_TASK_DMNS_BPMNS_PATH=<PATH_TO_DMN_REPO>
```

**Note:** _the values for the above environment variables can be found on
this [Confluence Page](https://tools.hmcts.net/confluence/display/WA/Camunda+Enterprise+Licence+Key)_. If you cannot
access the page, check with one of the team members.

### 3. Login:

```shell
./environment login
```

### 4. Pre-pulling (Recommended but optional):

*Note: this step could take a while to complete as it pull all the necessary images*


```shell
./environment pull
```

### 5. Build and start local WA environment:

```shell
./environment up
```

:warning: You probably notice that the xui-webapp pod is not running. This is because it's waiting for the wiremock
service to be up. This is a manual step for the moment. Therefore, run the following:

```shell
./scripts/setup.sh
```

### 6. Run service:

To run any of the service, Ingress should be enabled

##### 1. Update /etc/hosts to route the hosts to the minikube cluster ip

```shell
echo "$(minikube ip) ccd-shared-database service-auth-provider-api ccd-user-profile-api shared-db idam-web-public fr-am fr-idm sidam-api ccd-definition-store-api idam-web-admin idam-web-public ccd-definition-store-api ccd-data-store-api ccd-api-gateway wiremock xui-webapp ccd-case-management-web camunda-local-bpm role-assignment sidam-simulator" | sudo tee -a /etc/hosts
```

`$(minikube ip` should be populated automatically. If not you can replace it manually to get minikube ip, run
cmd `minikube ip` on the terminal.

##### 2. Verify the deployment

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

To run any service type
`http://<name-of-service>`

For example:

`http://xui-webapp`

If you are using safari browser and if you see page error. Try with chrome.

### 7. To stop and teardown local WA environment:

If you need to stop and teardown run cmd

```shell
./environment down
```

## Features

### CCD message publishing to Azure Service Bus

The ccd message publishing app is a service that periodically checks the ccd database for unpublished messgaes and
publishes those messages to an azure service bus topic.

If you need to enable the ccd-message-publishing add the AZURE_SERVICE_BUS_CONNECTION_STRING variable and value on
your `.bash_profile` and resource the file before running environment up.

```shell
export AZURE_SERVICE_BUS_CONNECTION_STRING="Endpoint=sb://REPLACE_ME.servicebus.windows.net/;SharedAccessKeyName=REPLACE_ME;SharedAccessKey=REPLACE_ME"
```
