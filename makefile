.PHONY: start environment-up-no-admin environment-reset-no-admin \
	ensure-environment-up-no-admin environment-up-no-admin-full \
	task-management-api-up-no-admin environment-reset-no-admin-full \
	shell-environment-no-admin \
	host-environment-up-no-admin \
	database-port-forwards-start database-port-forwards-stop database-port-forwards-status \
	application-port-forwards-start application-port-forwards-stop application-port-forwards-status \
	port-forwards-stop port-forwards-status

PROJECT_PATH:=$(PROVIDE_YOUR_PROJECT_PATH)
GIT_COMMANDS:=git checkout master; git gc; git pull origin master;
POSTGRES_LOCAL_PORT ?= 15432
POSTGRES_REPLICA_LOCAL_PORT ?= 15433
TASK_MANAGEMENT_API_DIR ?= $(abspath ../wa-task-management-api)

# Deploy Kubernetes without minikube tunnel or sudo. This target exposes the
# databases through fixed, unprivileged localhost ports after they are ready.
environment-up-no-admin:
	minikube start --addons=ingress,ingress-dns --driver=docker
	bash -c 'source .env && ./environment up'
	$(MAKE) database-port-forwards-start

# Recreate the cluster before running the password-free deployment.
environment-reset-no-admin:
	minikube stop
	minikube delete
	$(MAKE) environment-up-no-admin

# Start and deploy the cluster only when it is not already healthy.
ensure-environment-up-no-admin:
	@if minikube status >/dev/null 2>&1 && \
		./scripts/environment/is-environment-ready.sh >/dev/null 2>&1; then \
		echo "Minikube and the required environment services are already running."; \
	else \
		echo "The environment is stopped, missing, or only partially deployed; starting/resuming it..."; \
		$(MAKE) environment-up-no-admin; \
	fi

# Full password-free setup without deleting an existing cluster first.
environment-up-no-admin-full:
	$(MAKE) host-environment-up-no-admin

# Mirror the host-side setup and repository launch sequence from environment-up
# without using minikube tunnel or administrator privileges.
environment-reset-no-admin-full:
	$(MAKE) environment-reset-no-admin
	$(MAKE) host-environment-up-no-admin

# Continue the host-side setup when the pods are already deployed.
host-environment-up-no-admin:
	$(MAKE) ensure-environment-up-no-admin
	$(MAKE) shell-environment-no-admin
	./scripts/environment/run-host-setup-in-iterm.sh
	./scripts/environment/start-wa-repositories-no-admin.sh

task-management-api-up-no-admin: database-port-forwards-start application-port-forwards-start
	@test -x "$(TASK_MANAGEMENT_API_DIR)/gradlew" || \
		(echo "Cannot find wa-task-management-api at $(TASK_MANAGEMENT_API_DIR)"; exit 1)
	bash -c 'source scripts/environment/activate-local-databases.sh && \
		export SPRING_PROFILES_ACTIVE=replica && \
		cd "$(TASK_MANAGEMENT_API_DIR)" && \
		exec ./gradlew clean bootRun \
			--args="--replication.subscriptionUrl=postgresql://ccd-shared-database:5432"'

shell-environment-no-admin: database-port-forwards-start application-port-forwards-start
	./scripts/environment/persist-local-environment.sh

database-port-forwards-start:
	POSTGRES_LOCAL_PORT=$(POSTGRES_LOCAL_PORT) \
	POSTGRES_REPLICA_LOCAL_PORT=$(POSTGRES_REPLICA_LOCAL_PORT) \
	./scripts/environment/database-port-forwards.sh start

database-port-forwards-stop:
	./scripts/environment/database-port-forwards.sh stop

database-port-forwards-status:
	./scripts/environment/database-port-forwards.sh status

application-port-forwards-start:
	./scripts/environment/application-port-forwards.sh start

application-port-forwards-stop:
	./scripts/environment/application-port-forwards.sh stop

application-port-forwards-status:
	./scripts/environment/application-port-forwards.sh status

port-forwards-stop:
	$(MAKE) application-port-forwards-stop
	$(MAKE) database-port-forwards-stop

port-forwards-status:
	$(MAKE) database-port-forwards-status
	$(MAKE) application-port-forwards-status

# Start Environment
environment-up:
	@echo "Environment setup started!!!!"

	open -a docker
	@read  -p "Is Docker up (y/n)?: " INPUT; \
	if [ "y" != "$$INPUT" ]; then \
		while [ "y" != "$$INPUT" ] ; do \
				echo "\nIs Docker up (y/n)?\n"; \
				sleep 4; \
				read INPUT; \
			done; \
			true; \
	fi

	minikube start --addons=ingress,ingress-dns --driver=docker

	@echo "Minikube Tunnel"
	sleep 2;
	osascript \
    -e 'tell application "iTerm" to activate' \
        -e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using {command down, shift down}' \
    	-e 'tell application "System Events" to tell process "iTerm" to keystroke "i" using command down' \
    	-e 'tell application "System Events" to tell process "iTerm" to keystroke "Minikube Tunnel"' \
    	-e 'tell application "System Events" to tell process "iTerm" to key code 53' \
    	-e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/wa-kube-environment;"' \
        -e 'tell application "System Events" to tell process "iTerm" to key code 52' \
        -e 'tell application "System Events" to tell process "iTerm" to keystroke "sudo minikube tunnel;"' \
        -e 'tell application "System Events" to tell process "iTerm" to key code 52';

	@read  -p "Is minikube tunnelling started (y/n)?: " INPUT; \
    	if [ "y" != "$$INPUT" ]; then \
    		while [ "y" != "$$INPUT" ] ; do \
    				echo "\nHas minikube tunnelling started (y/n)?\n"; \
    				sleep 4; \
    				read INPUT; \
    			done; \
    			true; \
    	fi

	@echo "wa-kube-environment starting"
	sleep 1;
	osascript \
    -e 'tell application "iTerm" to activate' \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using {command down, shift down}' \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "i" using command down' \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "wa-kube-environment"' \
	-e 'tell application "System Events" to tell process "iTerm" to key code 53' \
    -e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/wa-kube-environment;"' \
    -e 'tell application "System Events" to tell process "iTerm" to key code 52' \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "$$(source .env);"' \
	-e 'tell application "System Events" to tell process "iTerm" to key code 52' \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "./environment up"' \
    -e 'tell application "System Events" to tell process "iTerm" to key code 52' \

	@read  -p "Is kube environment up (y/n)?: " INPUT; \
	if [ "y" != "$$INPUT" ]; then \
		while [ "y" != "$$INPUT" ] ; do \
				kubectl get pods -n hmcts-local ; \
				echo "\nIs kube environment up (y/n)?\n"; \
				sleep 4; \
				read INPUT; \
			done; \
			true; \
	fi


	@echo "Fetch POSTGRES_PORT"
	sleep 1;
	osascript \
    -e 'tell application "iTerm" to activate' \
    -e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using {command down, shift down}' \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "i" using command down' \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "Set POSTGRES_PORT"' \
	-e 'tell application "System Events" to tell process "iTerm" to key code 53' \
    -e 'tell application "System Events" to tell process "iTerm" to keystroke "minikube service ccd-shared-database --url -n hmcts-local;"' \
    -e 'tell application "System Events" to tell process "iTerm" to key code 52';

	sudo sed -i "" '/POSTGRES_PORT/d' ~/.bash_profile
	@echo "POSTGRES_PORT removed from ~/.bash_profile"
	sleep 1;

	@read  -p "Please provide POSTGRES_PORT: " INPUT; \
    	if [ "" != "$$INPUT" ]; then \
    		echo "export POSTGRES_PORT=$${INPUT}" | sudo tee -a ~/.bash_profile \
    		true; \
    	fi

	@echo "Fetch POSTGRES_REPLICA_PORT"
	sleep 1;
	osascript \
    -e 'tell application "iTerm" to activate' \
    -e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using {command down, shift down}' \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "i" using command down' \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "Set POSTGRES_REPLICA_PORT"' \
	-e 'tell application "System Events" to tell process "iTerm" to key code 53' \
    -e 'tell application "System Events" to tell process "iTerm" to keystroke "minikube service ccd-shared-database-replica --url -n hmcts-local;"' \
    -e 'tell application "System Events" to tell process "iTerm" to key code 52';

	sudo sed -i "" '/POSTGRES_REPLICA_PORT/d' ~/.bash_profile
	@echo "POSTGRES_REPLICA_PORT removed from ~/.bash_profile"
	sleep 1;

	@read  -p "Please provide POSTGRES_REPLICA_PORT: " INPUT; \
    	if [ "" != "$$INPUT" ]; then \
    		echo "export POSTGRES_REPLICA_PORT=$${INPUT}" | sudo tee -a ~/.bash_profile \
    		true; \
    	fi

	@echo "Ingress Update"
	sleep 1;
	osascript \
    -e 'tell application "iTerm" to activate' \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using {command down, shift down}' \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "i" using command down' \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "ingress-update"' \
	-e 'tell application "System Events" to tell process "iTerm" to key code 53' \
    -e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/wa-kube-environment/;"' \
    -e 'tell application "System Events" to tell process "iTerm" to key code 52' \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "$$(source ~/.bash_profile);"' \
	-e 'tell application "System Events" to tell process "iTerm" to key code 52' \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "./environment patch"' \
    -e 'tell application "System Events" to tell process "iTerm" to key code 52' \

	sleep 5;
	@echo "setup script is starting..."
	osascript \
    -e 'tell application "iTerm" to activate' \
    -e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using {command down, shift down}' \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "i" using command down' \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "Kube Setup Script"' \
	-e 'tell application "System Events" to tell process "iTerm" to key code 53' \
    -e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/wa-kube-environment;"' \
    -e 'tell application "System Events" to tell process "iTerm" to key code 52' \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "cd scripts; ./setup.sh"' \
    -e 'tell application "System Events" to tell process "iTerm" to key code 52';

	@read  -p "Has setup script completed (y/n)?: " INPUT; \
	if [ "y" != "$$INPUT" ]; then \
	  	sleep 4; \
		while [ "y" != "$$INPUT" ] ; do \
				sleep 4; \
				read INPUT; \
			done; \
			true; \
	fi

	@echo "wa-ccd-definitions is starting..."
	sleep 2;
	osascript \
    -e 'tell application "iTerm" to activate' \
    -e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using {command down, shift down}' \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "i" using command down' \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "wa-ccd-definitions"' \
	-e 'tell application "System Events" to tell process "iTerm" to key code 53' \
    -e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/wa-ccd-definitions;"' \
    -e 'tell application "System Events" to tell process "iTerm" to key code 52' \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "yarn upload-wa;"' \
    -e 'tell application "System Events" to tell process "iTerm" to key code 52';

	@echo "wa-workflow-api is starting..."
	sleep 2;
	osascript \
    -e 'tell application "iTerm" to activate' \
    -e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using command down' \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "i" using command down' \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "wa-workflow-api"' \
	-e 'tell application "System Events" to tell process "iTerm" to key code 53' \
    -e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/wa-workflow-api; bootRun;"' \
    -e 'tell application "System Events" to tell process "iTerm" to key code 52';

# Return main screen
	sleep 4; \
	osascript \
		-e 'tell application "iTerm" to activate' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "1" using {command down, option down}' ;


	@read  -p "Would you like to run wa-task-management-api (y/n)?: " INPUT; \
            if [ "y" = "$$INPUT" ]; then \
                osascript \
                    -e 'tell application "iTerm" to activate' \
                    -e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using command down' \
					-e 'tell application "System Events" to tell process "iTerm" to keystroke "i" using command down' \
					-e 'tell application "System Events" to tell process "iTerm" to keystroke "wa-task-management-api"' \
					-e 'tell application "System Events" to tell process "iTerm" to key code 53' \
                    -e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/wa-task-management-api; export SPRING_PROFILES_ACTIVE=replica; bootRun;"' \
                    -e 'tell application "System Events" to tell process "iTerm" to key code 52'; \
            fi

	@read  -p "Would you like to run wa-task-monitor (y/n)?: " INPUT; \
            if [ "y" = "$$INPUT" ]; then \
              osascript \
                    -e 'tell application "iTerm" to activate' \
                    -e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using command down' \
					-e 'tell application "System Events" to tell process "iTerm" to keystroke "i" using command down' \
					-e 'tell application "System Events" to tell process "iTerm" to keystroke "wa-task-monitor"' \
					-e 'tell application "System Events" to tell process "iTerm" to key code 53' \
                    -e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/wa-task-monitor; bootRun;"' \
                    -e 'tell application "System Events" to tell process "iTerm" to key code 52'; \
            fi

	@read  -p "Would you like to run wa-case-event-handler (y/n)?: " INPUT; \
            if [ "y" = "$$INPUT" ]; then \
                osascript \
                    -e 'tell application "iTerm" to activate' \
                    -e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using command down' \
					-e 'tell application "System Events" to tell process "iTerm" to keystroke "i" using command down' \
					-e 'tell application "System Events" to tell process "iTerm" to keystroke "wa-case-event-handler"' \
					-e 'tell application "System Events" to tell process "iTerm" to key code 53' \
                    -e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/wa-case-event-handler;"' \
                    -e 'tell application "System Events" to tell process "iTerm" to key code 52' \
                    \
					-e 'tell application "System Events" to tell process "iTerm" to keystroke "$$(source ~/.zshrc)"' \
					-e 'tell application "System Events" to tell process "iTerm" to key code 52' \
					\
					-e 'tell application "System Events" to tell process "iTerm" to keystroke "ceh-bootrun;"' \
					-e 'tell application "System Events" to tell process "iTerm" to key code 52'; \
            fi

	@read  -p "Would you like to run wa-post-deployment-ft-tests (y/n)?: " INPUT; \
            if [ "y" = "$$INPUT" ]; then \
                osascript \
                    -e 'tell application "iTerm" to activate' \
                    -e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using command down' \
					-e 'tell application "System Events" to tell process "iTerm" to keystroke "i" using command down' \
					-e 'tell application "System Events" to tell process "iTerm" to keystroke "wa-post-deployment-ft-tests"' \
					-e 'tell application "System Events" to tell process "iTerm" to key code 53' \
                    -e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/wa-post-deployment-ft-tests;"' \
                    -e 'tell application "System Events" to tell process "iTerm" to key code 52' \
                    \
					-e 'tell application "System Events" to tell process "iTerm" to keystroke "$$(source ~/.zshrc);"' \
					-e 'tell application "System Events" to tell process "iTerm" to key code 52' \
					\
					-e 'tell application "System Events" to tell process "iTerm" to keystroke "pdt-functional;"' \
					-e 'tell application "System Events" to tell process "iTerm" to key code 52'; \
            fi

	@echo "\n\n\n\nAll environment will be ready in a few seconds!!!!"

# Pull latest images
pull:
	osascript \
		-e 'tell application "iTerm" to activate' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using {command down, shift down}' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "i" using command down' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "wa-kube-environment"' \
		-e 'tell application "System Events" to tell process "iTerm" to key code 53' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/wa-kube-environment; ${GIT_COMMANDS}"' \
		-e 'tell application "System Events" to tell process "iTerm" to key code 52';

	sleep 4; \

	osascript \
		-e 'tell application "iTerm" to activate' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using {command down, shift down}' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "i" using command down' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "wa-case-event-handler"' \
		-e 'tell application "System Events" to tell process "iTerm" to key code 53' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/wa-case-event-handler; ${GIT_COMMANDS}"' \
		-e 'tell application "System Events" to tell process "iTerm" to key code 52';

	sleep 4; \

	osascript \
		-e 'tell application "iTerm" to activate' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using {command down, shift down}' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "i" using command down' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "wa-post-deployment-ft-tests"' \
		-e 'tell application "System Events" to tell process "iTerm" to key code 53' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/wa-post-deployment-ft-tests; ${GIT_COMMANDS}"' \
		-e 'tell application "System Events" to tell process "iTerm" to key code 52';

	sleep 4; \

	osascript \
		-e 'tell application "iTerm" to activate' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using {command down, shift down}' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "i" using command down' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "wa-standalone-task-bpmn"' \
		-e 'tell application "System Events" to tell process "iTerm" to key code 53' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/wa-standalone-task-bpmn; ${GIT_COMMANDS}"' \
		-e 'tell application "System Events" to tell process "iTerm" to key code 52';

	sleep 4; \

	osascript \
		-e 'tell application "iTerm" to activate' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using {command down, shift down}' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "i" using command down' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "wa-task-management-api"' \
		-e 'tell application "System Events" to tell process "iTerm" to key code 53' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/wa-task-management-api; ${GIT_COMMANDS}"' \
		-e 'tell application "System Events" to tell process "iTerm" to key code 52';

	sleep 4; \

	osascript \
		-e 'tell application "iTerm" to activate' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "n" using command down' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "i" using command down' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "wa-task-monitor"' \
		-e 'tell application "System Events" to tell process "iTerm" to key code 53' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/wa-task-monitor; ${GIT_COMMANDS}"' \
		-e 'tell application "System Events" to tell process "iTerm" to key code 52';
	sleep 4; \

	osascript \
		-e 'tell application "iTerm" to activate' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using {command down, shift down}' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "i" using command down' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "wa-workflow-api"' \
		-e 'tell application "System Events" to tell process "iTerm" to key code 53' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/wa-workflow-api; ${GIT_COMMANDS}"' \
		-e 'tell application "System Events" to tell process "iTerm" to key code 52';

	sleep 4; \

	osascript \
		-e 'tell application "iTerm" to activate' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using {command down, shift down}' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "i" using command down' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "wa-ccd-definitions"' \
		-e 'tell application "System Events" to tell process "iTerm" to key code 53' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/wa-ccd-definitions; ${GIT_COMMANDS}"' \
		-e 'tell application "System Events" to tell process "iTerm" to key code 52';

	sleep 4; \

	osascript \
		-e 'tell application "iTerm" to activate' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using {command down, shift down}' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "i" using command down' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "wa-ccd-definition-processor"' \
		-e 'tell application "System Events" to tell process "iTerm" to key code 53' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/wa-ccd-definitions/ccd-definition-processor; ${GIT_COMMANDS}"' \
		-e 'tell application "System Events" to tell process "iTerm" to key code 52';

	sleep 4; \

	osascript \
		-e 'tell application "iTerm" to activate' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using {command down, shift down}' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "i" using command down' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "wa-task-configuration-template"' \
		-e 'tell application "System Events" to tell process "iTerm" to key code 53' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/wa-task-configuration-template; ${GIT_COMMANDS}"' \
		-e 'tell application "System Events" to tell process "iTerm" to key code 52';

	sleep 4;

	@echo "All done!!!!"
