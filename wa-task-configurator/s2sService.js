const axios = require("axios").default;
const debug = require("debug")("debug:s2sService");
const OTP = require("otp");
const colors = require("colors");

const buildRequest = (s2sUrl, microServiceName, secret) => {
  const options = {
    secret: secret,
  };

  const otp = new OTP(options);
  const oneTimePassword = otp.totp();

  return {
    uri: `${s2sUrl}/lease`,
    body: {
      microservice: microServiceName,
      oneTimePassword: oneTimePassword,
    },
  };
};

const requestServiceToken = async (s2sUrl, microServiceName, secret) => {
  console.log(`\nRequesting token...`.green);
  console.log(`\nservice: ${s2sUrl} \nmicroservice: ${microServiceName}`);

  const request = buildRequest(s2sUrl, microServiceName, secret);

  try {
    debug(`request: ${JSON.stringify(request)}`);
    let res = await axios.post(request.uri, request.body);
    const token = "Bearer " + res.data;
    console.log(`token: ${token}`);
    return token;
  } catch (err) {
    console.error(`There are errors: ${JSON.stringify(err)}`);
  }
};

module.exports.requestServiceToken = requestServiceToken;
