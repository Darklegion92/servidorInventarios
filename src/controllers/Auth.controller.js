const pool = require("../config/database");
const Sercices = require("../services");

async function crear(req, res) {
  res.setHeader("Content-Type", "application/json");

  const { usuario, password, asignacion, sucursal, idusuario } = req.body;
  try {
    if (password) {
      const resp = await pool.query(
        "INSERT INTO usuarios(usuario,password,asignacion,idrol,idsucursal,fechacreacion)" +
          " value(?,?,?,?,?,?)  ",
        [usuario, password, asignacion, 1, sucursal, new Date()]
      );
      res.status(200).send({ usuario: resp });
    } else {
      const resp = await pool.query(
        "UPDATE usuarios SET usuario =?, asignacion=?," +
          " idsucursal = (SELECT id FROM sucursales WHERE nombre=?) where idusuario=?",
        [usuario, asignacion, sucursal, idusuario]
      );
      res.status(200).send({ usuario: resp });
    }
  } catch (e) {
    console.log(e);
    res.status(501).send({ mensaje: "Error: " + e });
  }
}

async function consultar(req, res) {
  res.setHeader("Content-Type", "application/json");

  try {
    const datos = await pool.query(
      "SELECT u.usuario  as usuario ,u.asignacion as nombre,u.idusuario as idusuario,u.idsucursal as idsucursal,s.nombre as nombresucursal,u.idrol,u.fechacreacion FROM usuarios u, sucursales s" +
        " WHERE u.idsucursal=s.id"
    );

    if (datos.length > 0) {
      res.status(200).send(datos);
    } else
      res.status(201).send({ mensaje: "Usuario o Contraseña Incorrectos" });
  } catch (e) {
    res.status(501).send({ mensaje: "Error " + e });
    console.log(e);
  }
}

async function ingresar(req, res) {
  res.setHeader("Content-Type", "application/json");
  const { usuario, password } = req.body.values;

  try {
    const datos = await pool.query(
      "SELECT usuario,asignacion,idusuario,idsucursal,idrol,fechacreacion FROM usuarios WHERE usuario =? AND password=?",
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
async function validarToken(req, res) {
  res.setHeader("Content-Type", "application/json");
  console.log(req.idusuario);
  const datos = await pool.query(
    "SELECT usuario,asignacion,idusuario,idsucursal,idrol,fechacreacion FROM usuarios WHERE idusuario=?",
    [req.idusuario]
  );
  res.status(200).send(datos[0]);
}

function error(req, res) {
  res.setHeader("Content-Type", "application/json");
  res.status(404).send({ mensaje: "Página no encontrada" });
}

module.exports = {
  ingresar,
  validarToken,
  consultar,
  crear,
  error,
};
