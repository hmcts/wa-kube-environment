const axios = require("axios").default;
const debug = require("debug")("debug:camundaService");
const colors = require("colors");
const moment = require("moment");

const createdBefore = moment()
  .subtract(2, "minute")
  .format("yyyy-MM-DDTHH:mm:ss.SSS+0000");

const data = JSON.stringify({
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
  createdBefore: `${createdBefore}`,
  taskDefinitionKey: "processTask",
  processDefinitionKey: "wa-task-initiation-ia-asylum",
});

const config = (serviceToken, camundaUrl) => {
  return {
    method: "post",
    url: `${camundaUrl}/task`,
    headers: {
      ServiceAuthorization: serviceToken,
      "Content-Type": "application/json",
    },
    data: data,
  };
};

const getTasks = async (serviceToken, camundaUrl) => {
  console.log("\nRetrieving unconfigured tasks...".green);
  const configRequest = config(serviceToken, camundaUrl);
  console.log(`\nrequest: ${JSON.stringify(configRequest, null, 4)}`);

  try {
    let res = await axios.post(
      configRequest.url,
      configRequest.data,
      config(serviceToken)
    );
    console.log("\nRetrieved unconfigured tasks successfully:\n".green);
    console.log(
      `${JSON.stringify(res.data[0], null, 4)} ..., Found ${
        res.data.length
      } unconfigured tasks:`
    );

    return res.data;
  } catch (error) {
    console.error(error);
  }
};

module.exports = {
  getTasks,
};
