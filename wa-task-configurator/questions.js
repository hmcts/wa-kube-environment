const readlineSync = require("readline-sync");

const localService = "http://service-auth-provider-api";
const aatService =
  "http://rpe-service-auth-provider-aat.service.core-compute-aat.internal";
const serviceList = [localService, aatService];
const question1 = "Enter s2s url: ";

const microServiceNameList = [
  "wa_task_configuration_api",
  "wa_task_management_api",
];
const question2 = "Enter microservice name: ";

const question3 = "Enter microservice secret: ";

const questions = [question1, question2, question3];

function askUserQuestions() {
  const serviceIndex = readlineSync.keyInSelect(serviceList, question1);
  const serviceUrl = serviceList[serviceIndex];

  const microserviceNameIndex = readlineSync.keyInSelect(
    microServiceNameList,
    question2
  );
  const microserviceName = microServiceNameList[microserviceNameIndex];

  const secret = readlineSync.question(question3);

  console.log("Thanks for your answers.");
  const answers = {
    s2sUrl: serviceUrl,
    microserviceName: microserviceName,
    secret: secret,
  };
  console.log(answers);

  return answers;
}

module.exports = {
  askUserQuestions,
};
