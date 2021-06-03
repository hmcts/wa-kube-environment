const axios = require("axios").default;
const debug = require("debug")("debug:taskConfigurationService");
const colors = require("colors");

const config = (serviceToken, taskConfigurationApiUrl, taskId) => {
  return {
    method: "post",
    url: `${taskConfigurationApiUrl}/task/${taskId}`,
    headers: {
      ServiceAuthorization: serviceToken,
      "Content-Type": "application/json",
    },
    data: "",
  };
};

const reconfigureTask = async (
  serviceToken,
  taskConfigurationApiUrl,
  taskId,
  stats
) => {
  console.log("\nReconfiguring camunda task...".green);
  const configRequest = config(serviceToken, taskConfigurationApiUrl, taskId);
  console.log(`\nrequest: ${JSON.stringify(configRequest, null, 4)}`);

  try {
    let res = await axios.post(
      configRequest.url,
      configRequest.data,
      config(serviceToken)
    );
    stats.numFixedTasks++;
    console.log(
      `\nTask[taskId=${taskId}] was reconfigured successfully:`.green
    );
    console.log(`result: ${JSON.stringify(res.data, null, 4)}`);
  } catch (error) {
    stats.numFailedTasks++;
    console.error(
      `\nTask[taskId=${taskId}] failed to be reconfigured:\n`.green
    );
    debug(error);
  }

  return stats;
};

const configureTasksAndShowStats = (tasks, serviceToken, userAnswers) => {
  let partialStats = {
    numFixedTasks: 0,
    numFailedTasks: 0,
    totalTasks: 0,
  };
  tasks.forEach(async (task) => {
    const stats = await reconfigureTask(
      serviceToken,
      userAnswers.taskConfigurationUrl,
      task.id,
      partialStats
    );
    partialStats.totalTasks =
      partialStats.numFailedTasks + partialStats.numFixedTasks;
    console.log(`stats: ${JSON.stringify(stats)}`);
  });
};

module.exports = {
  configureTasksAndShowStats,
};
