.PHONY: start

PROJECT_PATH:=/Users/YOUR_USER_NAME/YOUR_PROJECT_FOLDER_NAME
GIT_COMMANDS:=git checkout master; git gc; git pull origin master;

# Start Environment
environment-up:
	@echo "Environment setup started!!!!"
	az login

	minikube start --memory=8192 --cpus=4 --driver=hyperkit --addons=ingress

	sudo sed -i "" '/192.168/d' /etc/hosts
	@echo "Old minikube ip removed from /etc/hosts"
	sleep 2;
	@echo "$$(minikube ip) ccd-shared-database service-auth-provider-api ccd-user-profile-api shared-db ccd-definition-store-api idam-web-admin ccd-definition-store-api ccd-data-store-api ccd-api-gateway wiremock xui-webapp camunda-local-bpm am-role-assignment sidam-simulator local-dm-store ccd-case-document-am-api" | sudo tee -a /etc/hosts
	@echo "New minikube ip put into /etc/hosts"

	@echo "wa-kube-environment starting"
	osascript \
    -e 'tell application "iTerm" to activate' \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using {command down, shift down}' \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "i" using command down' \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "wa-kube-environment"' \
	-e 'tell application "System Events" to tell process "iTerm" to key code 53' \
    -e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/wa-kube-environment;"' \
    -e 'tell application "System Events" to tell process "iTerm" to key code 52' \
    \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "$$(source .env);"' \
	-e 'tell application "System Events" to tell process "iTerm" to key code 52' \
    \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "./environment up"' \
    -e 'tell application "System Events" to tell process "iTerm" to key code 52' \

	@read  -p "Is kube environment up (y/n)?: " INPUT; \
	if [ "y" != "$$INPUT" ]; then \
		while [ "y" != "$$INPUT" ] ; do \
				kubectl get pods -n hmcts-local ; \
				echo "\n\nIs kube environment up (y/n)?\n\n"; \
				sleep 4; \
				read INPUT; \
			done; \
			true; \
	fi

	@echo "run setup script"
	osascript \
    -e 'tell application "iTerm" to activate' \
    -e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using {command down, shift down}' \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "i" using command down' \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "setup.sh"' \
	-e 'tell application "System Events" to tell process "iTerm" to key code 53' \
    -e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/wa-kube-environment;"' \
    -e 'tell application "System Events" to tell process "iTerm" to key code 52' \
    \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "cd scripts; ./setup.sh"' \
    -e 'tell application "System Events" to tell process "iTerm" to key code 52';

	@read  -p "Is setup script completed (y/n)?: " INPUT; \
	if [ "y" != "$$INPUT" ]; then \
	  	sleep 4; \
		while [ "y" != "$$INPUT" ] ; do \
				echo "\n\nIs setup script completed (y/n)?\n\n"; \
				sleep 4; \
				read INPUT; \
			done; \
			true; \
	fi

	@echo "wa-ccd-definitions starting"
	sleep 5;
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

	@echo "wa-workflow-api starting"
	sleep 10;
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
                    -e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/wa-task-management-api; bootRun;"' \
                    -e 'tell application "System Events" to tell process "iTerm" to key code 52'; \
            fi

	@read  -p "Would you like to run wa-task-monitor (y/n)?: " INPUT; \
            if [ "y" = "$$INPUT" ]; then \
				@sleep 4; \
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
				@sleep 4; \
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
				@sleep 4; \
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

	@echo "\n\n\n\nAll environment will be ready in a few seconds!!!!\n\n\n\n"

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
