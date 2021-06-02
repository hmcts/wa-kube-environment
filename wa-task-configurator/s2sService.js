const axios = require("axios").default;
const s2sdebugger = require("debug")("debug:s2sService");
const OTP = require("otp");

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
  s2sdebugger(
    `Requesting token... \nservice: ${s2sUrl} \nmicroservice: ${microServiceName}`
  );

  const request = buildRequest(s2sUrl, microServiceName, secret);

  try {
    s2sdebugger(`request: ${JSON.stringify(request)}`);
    let res = await axios.post(request.uri, request.body);
    const result = "Bearer " + res.data;
    s2sdebugger(`result: ${result}`);
    return result;
  } catch (err) {
    s2sdebugger(`There are errors: ${JSON.stringify(err)}`);
  }
};

module.exports.requestServiceToken = requestServiceToken;
