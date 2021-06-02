const axios = require("axios").default;
const OTP = require("otp");
const moment = require("moment");

/**
 * Assembles a serviceAuthProvider request object to be used to query the service.
 * It also creates a one-time-password from the secret.
 *
 */
function buildRequest(s2sUrl, microServiceName, secret) {
  const options = {
    secret: secret
  };

  const otp = new OTP(options);
  const oneTimePassword = otp.totp();

  return {
    uri: `${s2sUrl}/lease`,
    body: {
      microservice: microServiceName,
      oneTimePassword: oneTimePassword,
    }
  };
}

/**
 * Request token to the serviceAuthProviderApp
 * Note: This token is stored in memory and this token is only valid for 3 hours.
 */
async function requestServiceToken(s2sUrl, microServiceName, secret) {
  console.info(
    `Requesting token... \nservice: ${s2sUrl} \nmicroservice: ${microServiceName}`
  );

  const request = buildRequest(s2sUrl, microServiceName, secret);

  try {
    console.info(`request: ${JSON.stringify(request)}`);
    let res = await axios.post(request.uri, request.body);
    console.info(`result: Bearer ${res.data}`);
    return res.data;
  } catch (err) {
    console.error(`There are errors: ${JSON.stringify(err)}`);
  }
}

module.exports.requestServiceToken = requestServiceToken;
