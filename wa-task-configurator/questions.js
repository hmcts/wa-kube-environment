const readlineSync = require("readline-sync");

const questions = ["Enter service url: ", "Enter microservice name: "];
const answers = [];

function askUserQuestions() {
  const serviceUrl = readlineSync.question(questions[0]);
  const microserviceName = readlineSync.question(questions[1]);
  answers.push(serviceUrl, microserviceName);
  console.log('Thanks for your answers.');
  console.log(answers);
  return answers;
};

module.exports = {
  askUserQuestions
};
