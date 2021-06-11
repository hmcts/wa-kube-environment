const axios = require("axios").default;
const s2sUtility = require("./s2sService");
const questionService = require("./questionService");
const camundaService = require("./camundaService");
const mainDebugger = require("debug")("debug:main");
const colors = require("colors");
const taskConfigurationService = require("./taskConfigurationService");
const bannerService = require("./bannerService");

const taskConfigurator = async () => {
  await bannerService.banner();

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
    taskConfigurationService.configureTasksAndShowStats(
      tasks,
      serviceToken,
      userAnswers
    );
};

taskConfigurator();
