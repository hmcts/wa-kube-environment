/** First Argument is CamundaURL second is Task-Config URL
*  Second Argument is the task configuratoin URL
*  Third Argument microserviceName 
*  Fourth Argument s2sUrl
*  Fith Argument s2s Secret
*/
const axios = require('axios').default;
const otp = require('otp');
const moment = require('moment');
const args = process.argv;

const CAMUNDA_URL = args[2]
const WA_TASK_CONFIGURATION_URL = args[3]
const microServiceName = args[4];
const s2sUrl = args[5];
const s2sSecret = args[6];

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

/**
 * Sends out a request to the serviceAuthProvider and request a new service token
 * to be passed as a header in any outgoing calls.
 * Note: This token is stored in memory and this token is only valid for 3 hours.
 */
async function requestServiceToken() {
  logger.trace('Attempting to request a S2S token', logLabel);
  const request = buildRequest();
  let res;
  try {
    res = await axios.post(request.uri, request.body);
  } catch (err) {
    logger.exception(err, logLabel);
  }
  if (res && res.data) {
    logger.trace('Received S2S token and stored token', logLabel);
    return  res.data;
  } else {
    logger.exception('Could not retrieve S2S token', logLabel);
  }
}


async function configureTasks() {
  const currentTime = moment().format('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
  const createdBefore = moment(currentTime).subtract(1, 'minute');

  const headers = {
    header: {
      'Content-Type': 'application/json'
    }
  }
  CAMUNDA_URL
  const taskQuery = {
    'orQueries': [
      {
        'taskVariables': [
          {
            'name': 'taskState',
            'operator': 'eq',
            'value': 'unconfigured'
          }
        ]
      }
    ],
    'createdBefore': createdBefore,
    'taskDefinitionKey': 'processTask',
    'processDefinitionKey': 'wa-task-initiation-ia-asylum'
  }

  const getCamundaTasks =  await axios.post(CAMUNDA_URL, taskQuery, headers)

  const serviceAuthorization = requestServiceToken();
  getCamundaTasks.data.forEach( task  => async () =>{
    WA_TASK_CONFIGURATION_URL
    //LOOP OVER TASKS
    await axios.post(`${WA_TASK_CONFIGURATION_URL}/${task.id}`,null,{
      header: {
        'Content-Type': 'application/json',
        "ServiceAuthorization": serviceAuthorization

      }
    });
  })
}
