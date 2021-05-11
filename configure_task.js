const axios = require('axios').default;
const microServiceName = "S2S_MICROSERVICE_NAME";
const s2sUrl = "S2S_URL";
const s2sSecret = "S2S_SECRET";
const otp = require('otp');

/**
 * Assembles a serviceAuthProvider request object to be used to query the service
 * also creates a one-time-password from the secret.
 */
function buildRequest() {
  const uri = `${s2sUrl}/lease`;
  const oneTimePassword = otp(s2sSecret).totp();
  return {
    uri: uri,
    body: {
      microservice: microServiceName,
      oneTimePassword: oneTimePassword
    }
  };
}



async function configureTasks() {
  const headers = {
    header: {
      'Content-Type': 'application/json'
    }
  }
  const CAMUNDA_URL = "http://camunda-api-aat.service.core-compute-aat.internal/engine-rest/task"
  const taskQuery = {
    'orQueries': [
      {
        'processVariables': [
          {
            'name': 'taskState',
            'operator': 'eq',
            'value': 'unconfigured'
          }
        ]
      }
    ],
    'taskDefinitionKey': 'processTask',
    'processDefinitionKey': 'wa-task-initiation-ia-asylum'
  }

  const getCamundaTasks =  await axios.post(CAMUNDA_URL, taskQuery, headers)
    .then(res => console.log(res.data))
    .catch(err => console.log(err))


  getCamundaTasks.forEach( task  => async () =>{
    const WA_TASK_CONFIGURATION_URL = "http://wa-task-configuration-api-aat.service.core-compute-aat.internal/task/"
    //LOOP OVER TASKS
    const configureTask =  await axios.post(WA_TASK_CONFIGURATION_URL+'/'+task.id,null,{
      header: {
        'Content-Type': 'application/json',
        "ServiceAuthorization": buildRequest()

      }
    });
  })



}
