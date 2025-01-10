.PHONY: start

PROJECT_PATH:=$(PROVIDE_YOUR_PROJECT_PATH)
GIT_COMMANDS:=git checkout master; git gc; git pull origin master;

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
