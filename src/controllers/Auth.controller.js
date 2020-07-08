const pool = require("../config/database");
const Sercices = require("../services");

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
    const token = Sercices.createToken(resp);
    res.status(200).send({ token, usuario: resp[0] });
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
      const token = Sercices.createToken(datos);
      res.status(200).send({ token, usuario: datos[0] });
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
