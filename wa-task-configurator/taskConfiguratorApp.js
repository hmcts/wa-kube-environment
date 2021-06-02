const axios = require("axios").default;
const moment = require("moment");
const s2sUtility = require("./s2sUtility");
const questions = require("./questions");
const camundaService = require("./camundaService");

async function configureTasks() {
  const createdBefore = moment()
    .subtract(1, "minute")
    .format("yyyy-MM-DDTHH:mm:ss.SSS+0000");
  const headers = {
    header: {
      "Content-Type": "application/json",
    },
  };
  const taskQuery = {
    orQueries: [
      {
        taskVariables: [
          {
            name: "taskState",
            operator: "eq",
            value: "unconfigured",
          },
        ],
      },
    ],
    createdBefore: createdBefore,
    taskDefinitionKey: "processTask",
    processDefinitionKey: "wa-task-initiation-ia-asylum",
  };

  const getCamundaTasks = await axios.post(CAMUNDA_URL, taskQuery, headers);
  console.info(getCamundaTasks.data.length, " tasks unconfigured");

  const serviceAuthorization = await requestServiceToken().catch((err) =>
    console.warn(err)
  );
  getCamundaTasks.data.forEach((task) => {
    //LOOP OVER TASKS
    axios.post(`${WA_TASK_CONFIGURATION_URL}/${task.id}`, null, {
      headers: {
        "Content-Type": "application/json",
        ServiceAuthorization: "Bearer " + serviceAuthorization,
      },
    });
  });

  const getCamundaTasksAfterConfigured = await axios.post(
    CAMUNDA_URL,
    taskQuery,
    headers
  );
  console.info(
    getCamundaTasksAfterConfigured.data.length,
    " tasks unconfigured"
  );
}

async function taskConfigurator() {
  const userAnswers = questions.askUserQuestions();

  const serviceToken = await s2sUtility.requestServiceToken(
    userAnswers.service,
    userAnswers.microserviceName,
    userAnswers.secret
  );

  const tasks = await camundaService.getTasks(serviceToken);

  tasks.forEach((task) => {
    if (task.id == "01fd7b95-b99f-11eb-8455-cead2af9477c") console.log(task);
  });
}

taskConfigurator();
