const axios = require("axios").default;
const moment = require("moment");
const s2sUtility = require("./s2sUtility");
const questions = require("./questions");
const david = require("./david");

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

const answers = questions.askUserQuestions();

// s2sUtility.requestServiceToken(answers[0], answers[1], answers[2]);

async function asyncCall() {
  console.log("calling");
  const token = await s2sUtility.requestServiceToken(
    answers[0],
    answers[1],
    answers[2]
  );
  console.log(token);
  // expected output: "resolved"
}

asyncCall();
