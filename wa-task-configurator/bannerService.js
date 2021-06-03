const art = require("ascii-art");

const banner = async () => {
  try {
    const banner = await art
      .font("WA  Task   configurator", "doom")
      .completed();
    const bannerWithStyle = await art.style(banner, "blink", true);
    console.log(bannerWithStyle);
  } catch (err) {
    console.log(err);
  }
};

module.exports = {
  banner,
};
