const pool = require("../config/database");
const Sercices = require("../services");

async function crear(req, res) {
  res.setHeader("Content-Type", "application/json");

  const { usuario, password, nombre, sucursal, idusuario, rol } = req.body;
  try {
    if (password) {
      const resp = await pool.query(
        "INSERT INTO usuarios(usuario,password,asignacion,idrol,idsucursal,fechacreacion)" +
          " value(?,?,?,?,?,?)  ",
        [usuario, password, nombre, rol, sucursal, new Date()]
      );
      res.status(200).send({ usuario: resp });
    } else {
      const resp = await pool.query(
        "UPDATE usuarios SET usuario =?, asignacion=?," +
          " idsucursal = (SELECT id FROM sucursales WHERE nombre=?),idrol=? where idusuario=?",
        [usuario, asignacion, sucursal, rol, idusuario]
      );
      res.status(200).send({ usuario: resp });
    }
  } catch (e) {
    console.log(e);
    res.status(501).send({ mensaje: "Error: " + e });
  }
}

async function actualizar(req, res) {
  res.setHeader("Content-Type", "application/json");

  const { newUser, user } = req.body;
  const { usuario, password, nombre, sucursal, rol } = newUser;
  try {
    let sql = "UPDATE usuarios set ? where idusuario=?";
    let parametros = [
      {
        usuario,
        asignacion: nombre,
        idsucursal: sucursal,
        password,
        idrol: rol,
      },
      user.idusuario,
    ];

    if (!password && user.nombresucursal === sucursal) {
      parametros = [
        { usuario, asignacion: nombre, idrol: rol },
        user.idusuario,
      ];
    } else if (!password) {
      parametros = [
        { usuario, asignacion: nombre, idsucursal: sucursal, idrol: rol },
        user.idusuario,
      ];
    } else if (user.idnombresucursal === sucursal) {
      parametros = [
        { usuario, asignacion: nombre, password, idrol: rol },
        user.idusuario,
      ];
    }
    const resp = await pool.query(sql, parametros);
    res.status(200).send({ usuario: resp });
  } catch (e) {
    console.log(e);
    res.status(501).send({ mensaje: "Error: " + e });
  }
}

async function consultar(req, res) {
  res.setHeader("Content-Type", "application/json");

  try {
    const datos = await pool.query(
      "SELECT u.usuario  as usuario ,u.asignacion as nombre,u.idusuario as idusuario,u.idsucursal as idsucursal,s.nombre as nombresucursal,u.idrol,u.fechacreacion,r.nombre as nombrerol" +
        " FROM usuarios u, sucursales s, roles r" +
        " WHERE u.idsucursal=s.id and r.idrol = u.idrol"
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
  actualizar,
  consultar,
  crear,
  error,
};
