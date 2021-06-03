const axios = require("axios").default;
const debug = require("debug")("debug:camundaService");
const colors = require("colors");

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
  console.log("\nRetrieving camunda tasks...".green);
  const configRequest = config(serviceToken, camundaUrl);
  console.log(`\nrequest: ${JSON.stringify(configRequest, null, 4)}`);

  try {
    let res = await axios.post(
      configRequest.url,
      configRequest.data,
      config(serviceToken)
    );
    console.log("\nRetrieved tasks successfully:\n".green);
    console.log(
      `${JSON.stringify(res.data[0], null, 4)} ..., total tasks: ${
        res.data.length
      }`
    );

    return res.data;
  } catch (error) {
    console.log(error);
  }
};

module.exports = {
  getTasks,
};
