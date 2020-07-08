const jwt = require("jsonwebtoken");
const moment = require("moment");
const keys = require("../config/keys");

function createToken(usuario) {
  const payload = {
    sub: usuario[0].idusuario + "J" + usuario[0].fechacreacion,
    iat: moment().unix(),
    exp: moment().add(1, "days").unix(),
  };

  return jwt.sign(payload, keys.SECRET_TOKEN);
}

async function decodeToken(token) {
  try {
    const payload = await jwt.decode(token, keys.SECRET_TOKEN);
    if (payload.exp >= moment().unix()) return payload.sub.split("J")[0];
    return 401;
  } catch (e) {
    return 500;
  }
}

module.exports = {
  createToken,
  decodeToken,
};
