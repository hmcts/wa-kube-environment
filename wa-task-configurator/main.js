const axios = require("axios").default;
const moment = require("moment");
const s2sUtility = require("./s2sService");
const questionService = require("./questionService");
const camundaService = require("./camundaService");
const mainDebugger = require("debug")("debug:main");
const colors = require("colors");
const taskConfigurationService = require("./taskConfigurationService");

const configureTasksAndShowStats = (tasks, serviceToken, userAnswers) => {
  let partialStats = {
    numFixedTasks: 0,
    numFailedTasks: 0,
    totalTasks: 0,
  };
  tasks.forEach(async (task) => {
    const stats = await taskConfigurationService.reconfigureTask(
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

const taskConfigurator = async () => {
  const userAnswers = questionService.askUserQuestions();

  const serviceToken = await s2sUtility.requestServiceToken(
    userAnswers.s2sUrl,
    userAnswers.microServiceName,
    userAnswers.secret
  );

  const tasks = await camundaService.getTasks(
    serviceToken,
    userAnswers.camundaUrl
  );

  const continueResult = await questionService.doYouWantToContinue();

  if (continueResult)
    configureTasksAndShowStats(tasks, serviceToken, userAnswers);
};

taskConfigurator();
