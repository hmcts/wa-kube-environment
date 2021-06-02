const axios = require("axios").default;
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
  console.info(
    `Requesting token... \nservice: ${s2sUrl} \nmicroservice: ${microServiceName}`
  );

  const request = buildRequest(s2sUrl, microServiceName, secret);

  try {
    console.info(`request: ${JSON.stringify(request)}`);
    let res = await axios.post(request.uri, request.body);
    const result = "Bearer " + res.data;
    console.info(`result: ${result}`);
    return result;
  } catch (err) {
    console.error(`There are errors: ${JSON.stringify(err)}`);
  }
};

module.exports.requestServiceToken = requestServiceToken;
