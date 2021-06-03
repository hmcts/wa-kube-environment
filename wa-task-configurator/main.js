const axios = require("axios").default;
const moment = require("moment");
const s2sUtility = require("./s2sService");
const questions = require("./questionService");
const camundaService = require("./camundaService");
const mainDebugger = require("debug")("debug:main");
const colors = require("colors");
const taskConfigurationService = require("./taskConfigurationService");

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
    taskConfigurationService.reconfigureTask(
      serviceToken,
      userAnswers.taskConfigurationUrl,
      task.id
    );
  });

}

taskConfigurator();
