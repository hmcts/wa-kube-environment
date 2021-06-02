const readlineSync = require("readline-sync");

const s2sOptions = [
  "http://service-auth-provider-api",
  "http://rpe-service-auth-provider-aat.service.core-compute-aat.internal",
];
const s2sQuestion = "Enter s2s url: ";

const serviceNameOptions = [
  "wa_task_configuration_api",
  "wa_task_management_api",
];
const serviceNameQuestion = "Enter microservice name: ";

const secretQuestion = "Enter microservice secret: ";

const camundaUrlOptions = [
  "http://camunda-local-bpm/engine-rest",
  "http://camunda-api-aat.service.core-compute-aat.internal/engine-rest",
];
const camundaUrlQuestion = "Enter camunda url: ";

const questions = [
  s2sQuestion,
  serviceNameQuestion,
  secretQuestion,
  camundaUrlQuestion,
];

function askUserQuestions() {
  const s2sUrlOption = readlineSync.keyInSelect(s2sOptions, s2sQuestion);
  const s2sUrl = s2sOptions[s2sUrlOption];

  const microServiceNameOption = readlineSync.keyInSelect(
    serviceNameOptions,
    serviceNameQuestion
  );
  const microServiceName = serviceNameOptions[microServiceNameOption];

  const secret = readlineSync.question(secretQuestion);

  const camundaUrlOption = readlineSync.keyInSelect(
    camundaUrlOptions,
    camundaUrlQuestion
  );
  const camundaUrl = camundaUrlOptions[camundaUrlOption];

  console.log("Thanks for your answers.");
  const answers = {
    s2sUrl: s2sUrl,
    microServiceName: microServiceName,
    secret: secret,
    camundaUrl: camundaUrl,
  };
  console.log(answers);

  return answers;
}

module.exports = {
  askUserQuestions,
};
