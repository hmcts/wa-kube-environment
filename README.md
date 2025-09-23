# Work Allocation Dev Environment

[![License: MIT](https://img.shields.io/github/license/hmcts/wa-task-management-api)](https://opensource.org/licenses/MIT)

Last reviewed on: 10/06/2025

## Summary

A local development Kubernetes environment which provides all the dependencies required for the WA Task Management common service.  Uses helm charts and deployed with
helmfile.

Developers will need this running to be able to successfully run Functional Tests.

## Prerequisites

- HMCTS account
- Github access to public and private repositories. Need to have a Jira ticket (Reporting Mgr/Tech Lead will handle)
  Once the ticket is assigned, DevOps team will ask for user acceptance which can be done on this page
  https://tools.hmcts.net/confluence/display/RPE/Acceptable+Use+Policy+and+Contractor+Security+Guidance
- Access to Azure and container registry, clone https://github.com/hmcts/devops-azure-ad
  If you can't access it, then you do not have access to private repositories(Goto previous step) and check with Devops
  team. If you can access, then create a branch something like 'adding-permissions-your-name'.
- A local clone of the following repositories [wa-standalone-task-bpmn](https://github.com/hmcts/wa-standalone-task-bpmn) & [wa-task-configuration-template](https://github.com/hmcts/wa-task-configuration-template)
- This environment setup is intended to be used with Apple Mac machines running Apple silicone such as M1, M2, M3, M4 / M4 Max and other silicon chips. 
  For older Macs using Intel chips, use the branch: 'https://github.com/hmcts/wa-kube-environment/tree/kube-env-mac_intel_chips'.

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

The above can all brew installed via `brew install` or your preferred package manager.

## Quick start

### 1. Create a local cluster:

Latest Tested minikube version `v1.28.0`

If you are using minikube version v1.15.1 or later

```shell
minikube start \
     --memory=24000 \
     --cpus=16 \
     --addons=ingress,ingress-dns \
     --driver=docker
```

Note: 
We can use these commands to set the memory and cpu for the minikube cluster.
Adjust the values as is suitable for your particular machine
`minikube config set memory 15000`
`minikube config set cpus 8`
`minikube config set driver docker;`

To view the set configuration, run `minikube config view`


### 2. Environment variables

Source the .env file in the root of the project:

```shell
source .env
```

Set the following environment variables on your `.bash_profile` or `.zprofile`(for M2 & M1 chip macs)
and make sure the terminal can read `.bash_profile`

```
# Camunda
export WA_CAMUNDA_NEXUS_PASSWORD=change-me
export WA_CAMUNDA_NEXUS_USER=change-me

# Access Management
export AM_ROLE_SERVICE_SDK_KEY=change-me

#Launch Darkly Keys
export LAUNCH_DARKLY_SDK_KEY=change-me
export LAUNCH_DARKLY_ACCESS_TOKEN=change-me

# Docmosis and Address Lookup services
export ADDRESS_LOOKUP_TOKEN=change-me
export DOCMOSIS_ACCESS_KEY=change-me

```

**Note:** The values for sensitive environment variables listed above are securely stored in the MS Azure Vault within HMCTS.
There are some instructions if you have the required permissions here: [MiniKube Secrets](https://tools.hmcts.net/confluence/display/WA/Kube+Environment+Secrets)
See the following page regarding Camunda: [Camunda License](https://tools.hmcts.net/confluence/display/WA/Camunda+Enterprise+Licence+Key)_
For further info or help reach out to the Work Allocation / Task Management team members.

You will also need to provide the paths to essential Camunda artifacts

```
#export PROVIDE_YOUR_PROJECT_PATH=<PROJECT_PATH>
export WA_BPMNS_DMNS_PATH=<PATH_TO_BPMN_REPO>
export WA_TASK_DMNS_BPMNS_PATH=<PATH_TO_DMN_REPO>
```

**WA_BPMNS_DMNS_PATH** = File path to your local copy of the repository [wa-standalone-task-bpmn](https://github.com/hmcts/wa-standalone-task-bpmn)
**WA_TASK_DMNS_BPMNS_PATH** = File path to your local copy of the repository [wa-task-configuration-template](https://github.com/hmcts/wa-task-configuration-template)

### 3. Login:

```shell
./environment login
```

### 4. Pre-pulling (Recommended but optional):

*Note: this step could take a while to complete as it pull all the necessary images*

```shell
./environment pull
```

If you get an error regarding authentication when attempting to pull the images like:

  ```
  Attempting to pull HMCTS public image from hmctspublic.azurecr.io/am/role-assignment-service:latest
  Error response from daemon: Head https://hmctspublic.azurecr.io/v2/am/role-assignment-service/manifests/latest: unauthorized: authentication required  
  ```

Then it is likely because an authentication token has expired. To fix it simply run:

```shell
docker logout hmctspublic.azurecr.io
```

### 5. Build and start local WA environment:

```shell
./environment up
```

:warning: You probably notice that the xui-webapp pod is not running. This is because it's waiting for the wiremock
service to be up. This is a manual step for the moment. Therefore, run the following:

Note to run setup.sh you must have already run the first step to run the service below

```shell
   cd scripts
   ./setup.sh
```

### 6. Run service:

To run any of the service, Ingress should be enabled

##### 1. Update /etc/hosts to route the hosts to the minikube cluster ip

Generally this step need only be done once per installation, some environments like WSL do sometimes sneakily regnerate your hosts file.

It definitely needs to have been run once before setup script above is run.

```shell
echo "$(minikube ip) ccd-shared-database ccd-shared-database-replica service-auth-provider-api ccd-user-profile-api shared-db ccd-definition-store-api idam-web-admin ccd-definition-store-api ccd-data-store-api ccd-api-gateway wiremock xui-webapp camunda-local-bpm am-role-assignment sidam-simulator local-dm-store ccd-case-document-am-api" | sudo tee -a /etc/hosts
```

`$(minikube ip)` should be populated automatically. If not you can replace it manually to get minikube ip, run
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
   ccd-shared-database-replica-0                1/1     Running   0          2m
   sidam-api-59b66bf4cb-d24j6                   1/1     Running   0          5m19s
   wiremock-59669584fc-xcxjw                    1/1     Running   0          74s
   xui-webapp-7485d8c499-htmq5                  1/1     Running   0          71s
   ```

To run any service type
`http://<name-of-service>`

For example:

`http://xui-webapp`

If you are using safari browser and if you see page error. Try with chrome.

Users running under WSL will find this harder as they cannot so easily see the pages from the Windows GUI.

### 7. To stop and teardown local WA environment:

If you need to stop and teardown run cmd

```shell
./environment down
```
To remove all traces
```shell
minikube stop
minikube delete
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

### Database replication
For the Task Management app there are now 2 containers with Postrgesql databases called `cft_task_db` - Primary and Replica.  This uses logical replication and the scripts to setup that repication is in task-management-api and are run on startup. The replica can be connected to on Host:ccd-shared-database-replica Database: cft_task_db Port:5433, with the same wa_user. You will need to rerun the script above to add the new host name to your /etc/hosts file.

## Set-up Environment using makefile

To streamline the setup process there is a `makefile` which will run all the setup commands in sequence.  To use it:

Open `makefile` and set `PROJECT_PATH` value. The `pwd` command in a terminal returns project path.

Open a terminal run following command.

```shell
make environment-up
```
