const readlineSync = require("readline-sync");

const localService = "http://service-auth-provider-api";
const aatService =
  "http://rpe-service-auth-provider-aat.service.core-compute-aat.internal";
const serviceList = [localService, aatService];
const question1 = "Enter service url: ";

const microserviceNameList = ["wa_task_configuration_api", "wa_task_management_api"];
const question2 = "Enter microservice name: ";

const question3 = "Enter microservice secret: "

const questions = [question1, question2, question3];

const answers = [];

function askUserQuestions() {
  const serviceIndex = readlineSync.keyInSelect(serviceList, question1);
  const serviceUrl = serviceList[serviceIndex];

  const microserviceNameIndex = readlineSync.keyInSelect(
    microserviceNameList,
    question2
  );
  const microserviceName = microserviceNameList[microserviceNameIndex];

  const secret = readlineSync.question(question3);

  answers.push(serviceUrl, microserviceName, secret);

  console.log("Thanks for your answers.");
  console.log(answers);

  return answers;
}

module.exports = {
  askUserQuestions,
};
