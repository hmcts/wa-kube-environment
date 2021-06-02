const readlineSync = require("readline-sync");

const localService = "http://service-auth-provider-api";
const aatService =
  "http://rpe-service-auth-provider-aat.service.core-compute-aat.internal";
const serviceList = [localService, aatService];
const question1 = "Enter service url: ";

const microserviceNameList = ["wa_task_configuration_api", "wa_task_management_api"];
const question2 = "Enter microservice name: ";

const questions = [question1, question2];

const answers = [];

function askUserQuestions() {
  const serviceIndex = readlineSync.keyInSelect(serviceList, question1);
  const serviceUrl = serviceList[serviceIndex];

  const microserviceNameIndex = readlineSync.keyInSelect(
    microserviceNameList,
    question2
  );
  const microserviceName = microserviceNameList[microserviceNameIndex];

  answers.push(serviceUrl, microserviceName);

  console.log("Thanks for your answers.");
  console.log(answers);

  return answers;
}

module.exports = {
  askUserQuestions,
};
