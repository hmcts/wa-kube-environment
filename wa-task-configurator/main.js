const axios = require("axios").default;
const s2sUtility = require("./s2sService");
const questionService = require("./questionService");
const camundaService = require("./camundaService");
const mainDebugger = require("debug")("debug:main");
const colors = require("colors");
const taskConfigurationService = require("./taskConfigurationService");
const art = require("ascii-art");

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

const banner = async () => {
  try {
    const banner = await art
      .font("WA  Task   configurator", "doom")
      .completed();
    const bannerWithStyle = await art.style(banner, "blink", true);
    console.log(bannerWithStyle);
  } catch (err) {
    console.log(err);
  }
};

const taskConfigurator = async () => {
  await banner();

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
