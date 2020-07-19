const services = require("../services");

async function isAuth(req, res, next) {
  try {
    const token = req.headers.authorization;
    if (!token) {
      return res.status(403).send({ err: "No Tiene Autorización" });
    }

    const decoded = await services.decodeToken(token);

    if (decoded === 500) {
      res.status(500).send({ mensaje: "Token No valido" });
    }
    if (decoded === 401) {
      res.status(401).send({ mensaje: "Token Caducado" });
    }
    req.idusuario = decoded;
    next();
  } catch (e) {
    return res.status(403).send({ err: "No Tiene Autorización" });
  }
}

module.exports = {
  isAuth,
};
