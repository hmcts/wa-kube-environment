const readlineSync = require("readline-sync");
const debug = require("debug")("debug:questionService");
const colors = require("colors");

const availableUserOptions = [
  {
    env: "local",
    s2sUrl: "http://service-auth-provider-api",
    camundaUrl: "http://camunda-local-bpm/engine-rest",
  },
  {
    env: "AAT",
    s2sUrl:
      "http://rpe-service-auth-provider-aat.service.core-compute-aat.internal",
    camundaUrl:
      "http://camunda-api-aat.service.core-compute-aat.internal/engine-rest",
  },
];

function askUserQuestions() {
  console.log(
    "\n\nBefore starting, we ask you a few questions. It will be easy, I promise ;D ...\n\n"
      .brightGreen
  );

  const question = "Choose an option:";

  console.log("Choose the environment:".blue);
  const envOptions = availableUserOptions.map((o) => o.env);
  const selectedUserOption = readlineSync.keyInSelect(
    availableUserOptions.map((o) => o.env),
    question
  );

  console.log(
    "\n Enter the secret for the wa-task-configuration-api service in the s2s vault:"
      .blue
  );
  const secret = readlineSync.question("Enter secret: ");

  console.log("Thanks for your answers!".green);
  const answers = {
    s2sUrl: availableUserOptions[selectedUserOption].s2sUrl,
    microServiceName: "wa_task_configuration_api",
    secret: secret,
    camundaUrl: availableUserOptions[selectedUserOption].camundaUrl,
  };
  console.log(`${JSON.stringify(answers, null, 4)}`);

  return answers;
}

module.exports = {
  askUserQuestions,
};