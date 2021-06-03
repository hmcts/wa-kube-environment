# To run the task configurator app:

1. Add the following `MICROSERVICEKEY_WA_TASK_CONFIGURATION_API` environment variable and the value from the s2s vault. Finally, source your profile to apply changes:

```shell
source ~/.zshrc
```

2. Run yarn inside the wa-task-configurator folder:

```shell
yarn
```

3. Run the app, on your terminal:

```shell
DEBUG=debug:* node main.js
```

## Some notes

The DEBUG env var can target different services for debugging purpose: `DEBUG=debug:camundaService`.
