const axios = require("axios").default;
const debug = require("debug")("app:camundaService");

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
  try {
    const configRequest = config(serviceToken, camundaUrl);
    let res = await axios.post(configRequest.url, config(serviceToken));
    debug(
      `retrieved tasks successfully: ${JSON.stringify(
        res.data[0],
        null,
        4
      )} ..., total tasks: ${res.data.length}`
    );
    return res.data;
  } catch (error) {
    console.log(error);
  }
};

module.exports = {
  getTasks,
};
