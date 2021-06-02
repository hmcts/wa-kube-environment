const axios = require("axios").default;

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

const config = (serviceToken) => {
  return {
    method: "post",
    url: "http://camunda-api-aat.service.core-compute-aat.internal/engine-rest/task",
    headers: {
      ServiceAuthorization: serviceToken,
      "Content-Type": "application/json",
    },
    data: data,
  };
};

const getTasks = async (serviceToken) => {
  try {
    const configRequest = config(serviceToken);
    let res = await axios.post(configRequest.url, config(serviceToken));
    console.log(JSON.stringify(res.data, null, 4));
    return res.data;
  } catch (error) {
    console.log(error);
  }
};

module.exports = {
  getTasks,
};
