const axios = require("axios").default;
const moment = require("moment");
const s2sUtility = require("./s2sService");
const questions = require("./questionService");
const camundaService = require("./camundaService");
const mainDebugger = require("debug")("debug:main");

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
  mainDebugger(getCamundaTasks.data.length, " tasks unconfigured");

  const serviceAuthorization = await requestServiceToken().catch((err) =>
    mainDebugger(err)
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
  mainDebugger(
    getCamundaTasksAfterConfigured.data.length,
    " tasks unconfigured"
  );
}

async function taskConfigurator() {
  const userAnswers = questions.askUserQuestions();

  const serviceToken = await s2sUtility.requestServiceToken(
    userAnswers.s2sUrl,
    userAnswers.microServiceName,
    userAnswers.secret
  );

  const tasks = await camundaService.getTasks(
    serviceToken,
    userAnswers.camundaUrl
  );

  tasks.forEach((task) => {
    //call task-configuration-api/task/task.id
  });
}

taskConfigurator();
