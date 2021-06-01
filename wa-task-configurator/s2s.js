const axios = require("axios").default;

/**
 * Assembles a serviceAuthProvider request object to be used to query the service.
 * It also creates a one-time-password from the secret.
 *
 */
function buildRequest(s2sUrl, microServiceName) {
  return {
    uri: `${s2sUrl}/lease`,
    body: {
      microservice: microServiceName,
    },
  };
}

/**
 * Request token to the serviceAuthProviderApp
 * Note: This token is stored in memory and this token is only valid for 3 hours.
 */
async function requestServiceToken(s2sUrl, microServiceName) {
  console.info(
    `Requesting token to the service-auth-provider-app(${s2sUrl}) for microservice(${microServiceName})`
  );

  const request = buildRequest(s2sUrl, microServiceName);

  try {
    console.info(`making s2s request(${request})...`);
    let res = await axios.post(request.uri, request.body);
    console.info(`s2s token requested successfully: ${res.data}`);
    return res.data;
  } catch (err) {
    console.error(`There are errors: ${JSON.stringify(err)}`);
  }
}

module.exports.requestServiceToken = requestServiceToken;
