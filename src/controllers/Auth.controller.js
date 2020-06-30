const pool = require("../config/database");
const Token = require("../services/index.service");

async function crear(req, res) {
  res.setHeader("Content-Type", "application/json");

  const { usuario, password, idRol, asignacion } = req.body;

  const nuevoUsuario = {
    usuario,
    password,
    idRol,
    asignacion,
  };
  try {
    const resp = await pool.query("INSERT INTO usuarios SET ? ", [
      nuevoUsuario,
    ]);
    const token = Token.createToken(resp);
    res.status(200).send(token);
  } catch (e) {
    res.status(501).send({ mensaje: "Error: " + e });
  }
}

async function ingresar(req, res) {
  res.setHeader("Content-Type", "application/json");
  const { usuario, password } = req.body.values;

  try {
    const datos = await pool.query(
      "SELECT * FROM usuarios WHERE usuario =? AND password=?",
      [usuario, password]
    );

    if (datos.length > 0) {
      const token = Token.createToken(datos);
      res.status(200).send(token);
    } else
      res.status(201).send({ mensaje: "Usuario o Contraseña Incorrectos" });
  } catch (e) {
    res.status(501).send({ mensaje: "Error " + e });
    console.log(e);
  }
}

function error(req, res) {
  res.setHeader("Content-Type", "application/json");
  res.status(404).send({ mensaje: "Página no encontrada" });
}

module.exports = {
  ingresar,
  crear,
  error,
};
