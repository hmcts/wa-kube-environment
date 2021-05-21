//First Argument is CamundaURL second is Task-ConfigURL
const axios = require('axios').default;
const moment = require('moment');
const args = process.argv;

const CAMUNDA_URL = args[2]
const WA_TASK_CONFIGURATION_URL = args[3]
const microServiceName = args[4];
const s2sUrl = args[5];

/**
 * Assembles a serviceAuthProvider request object to be used to query the service
 * also creates a one-time-password from the secret.
 *
 */
function buildRequest() {
  const uri = `${s2sUrl}/lease`;

  return {
    uri: uri,
    body: {
      microservice: microServiceName
    }
  };
}

/**
 * Sends out a request to the serviceAuthProvider and request a new service token
 * to be passed as a header in any outgoing calls.
 * Note: This token is stored in memory and this token is only valid for 3 hours.
 */
async function requestServiceToken() {
  console.info('Attempting to request a S2S token');
  const request = buildRequest();

  let res;
  try {
    res = await axios.post(request.uri, request.body);
  } catch (err) {
    console.warn(err);
  }
  if (res && res.data) {
    console.info('Received S2S token and stored token');
    return  res.data;
  } else {
    console.warn('Could not retrieve S2S token');
  }
}


async function configureTasks() {
  const createdBefore = moment().subtract(1, 'minute').format('yyyy-MM-DDTHH:mm:ss.SSS+0000')
  const headers = {
    header: {
      'Content-Type': 'application/json'
    }
  }
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
  console.info(getCamundaTasks.data.length, " tasks unconfigured")

  const serviceAuthorization = await requestServiceToken()
    .catch(err => console.warn(err));
  getCamundaTasks.data.forEach( (task) =>{
    //LOOP OVER TASKS
     axios.post(`${WA_TASK_CONFIGURATION_URL}/${task.id}`,null,{
      headers: {
        'Content-Type': 'application/json',
        "ServiceAuthorization": "Bearer " + serviceAuthorization

      }
    })
  })

  const getCamundaTasksAfterConfigured =  await axios.post(CAMUNDA_URL, taskQuery, headers)
  console.info(getCamundaTasksAfterConfigured.data.length, " tasks unconfigured")
}

configureTasks();
