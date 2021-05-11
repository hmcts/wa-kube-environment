//First Argument is CamundaURL second is Task-ConfigURL
const args = process.argv;
const axios = require('axios').default;
const microServiceName = args[4];
const s2sUrl = args[5];
const s2sSecret = args[6];
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
  const CAMUNDA_URL = args[2]
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
    const WA_TASK_CONFIGURATION_URL = args[3]
    //LOOP OVER TASKS
    const configureTask =  await axios.post(WA_TASK_CONFIGURATION_URL+'/'+task.id,null,{
      header: {
        'Content-Type': 'application/json',
        "ServiceAuthorization": buildRequest()

      }
    });
  })



}
