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
  taskId
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
    console.log(
      `\nTask[taskId=${taskId}] was reconfigured successfully:`.green
    );
    console.log(`result: ${JSON.stringify(res.data, null, 4)}`);
  } catch (error) {
    console.log(`\nTask[taskId=${taskId}] failed to be reconfigured:\n`.green);
    debug(error);
  }
};

module.exports = {
  reconfigureTask,
};
