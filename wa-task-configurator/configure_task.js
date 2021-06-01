/** First Argument is CamundaURL second is Task-Config URL
 *  Second Argument is the task configuratoin URL
 *  Third Argument microserviceName
 *  Fourth Argument s2sUrl
 *  Fith Argument s2s Secret
 */
const axios = require("axios").default;
const moment = require("moment");
const s2sUtility = require("./s2s");
const args = process.argv;

// const CAMUNDA_URL = args[2]
// const WA_TASK_CONFIGURATION_URL = args[3]
const microServiceName = args[3];
const s2sUrl = args[2];

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

async function requestS2sToken(s2sUrl, microServiceName) {
  const token = await s2sUtility.requestServiceToken(s2sUrl, microServiceName);
  console.info(`token: ${token}`);
}

console.log("Start...");
s2sUtility.requestServiceToken(s2sUrl, microServiceName);
console.log("End");
