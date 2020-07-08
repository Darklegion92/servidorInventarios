const pool = require("../config/database");

async function consultar(req, res) {
  res.setHeader("Content-Type", "application/json");

  try {
    const datos = await pool.query(
      "SELECT p.*, t.prefijo,p.documento, r.nombre FROM proveedores p, tipos_documento t, regimenes r WHERE t.idtipo_documento = p.idtipo_documento " +
        "AND r.idregimen= p.idregimen;"
    );

    if (datos.length > 0) {
      res.status(200).send(datos);
    } else res.status(201).send({ mensaje: "No Se Encontraron Resultados" });
  } catch (e) {
    res.status(501).send({ mensaje: "Error " + e });
    console.log(e);
  }
}

async function consultarParametros(req, res) {
  res.setHeader("Content-Type", "application/json");

  const { tipo, dato } = req.params;
  let sql;
  if (tipo === "documento") {
    sql =
      "SELECT p.*, t.prefijo,p.documento, r.nombre FROM proveedores p, tipos_documento t, regimenes r WHERE t.idtipo_documento = p.idtipo_documento " +
      "AND r.idregimen= p.idregimen AND p.documento like '%" +
      dato +
      "%'";
  }

  if (tipo === "nombre") {
    sql =
      "SELECT p.*, t.prefijo,p.documento, r.nombre FROM proveedores p, tipos_documento t, regimenes r WHERE t.idtipo_documento = p.idtipo_documento " +
      "AND r.idregimen= p.idregimen AND (p.nombres like '%" +
      dato +
      "%' OR p.apellidos like '%" +
      dato +
      "%')";
  }

  try {
    const datos = await pool.query(sql, dato);
    
    if (datos.length > 0) {
      res.status(200).send(datos);
    } else res.status(201).send({ mensaje: "No Se Encontraron Resultados" });
  } catch (e) {
    res.status(501).send({ mensaje: "Error " + e });
    console.log(e);
  }
}

async function editar(req, res) {
  res.setHeader("Content-Type", "application/json");

  const {
    idproveedor,
    idtipo_documento,
    documento,
    razonsocial,
    nombres,
    apellidos,
    direccion,
    telefono,
    correo,
    idregimen,
  } = req.body;

  try {
    let datos = await pool.query(
      "UPDATE proveedores SET idtipo_documento=?, documento=?,razonsocial=?, nombres=?,apellidos=?," +
        "direccion=?,telefono=?,correo=?,idregimen=? WHERE idproveedor=?",
      [
        idtipo_documento,
        documento,
        razonsocial,
        nombres,
        apellidos,
        direccion,
        telefono,
        correo,
        idregimen,
        idproveedor,
      ]
    );

    if (datos.affectedRows > 0) {
      datos = await pool.query("SELECT * FROM proveedores");
      res.status(200).send(datos);
    } else res.status(201).send({ mensaje: "No Se Actualizo El Campo" });
  } catch (e) {
    res.status(501).send({ mensaje: "Error " + e });
    console.log(e);
  }
}

async function crear(req, res) {
  res.setHeader("Content-Type", "application/json");
  const {
    idproveedor,
    idtipo_documento,
    documento,
    razonsocial,
    nombres,
    apellidos,
    direccion,
    telefono,
    idregimen,
    correo,
  } = req.body;
  const { idusuario } = req;
  const fechacreacion = new Date();

  try {
    let datos = await pool.query("INSERT INTO proveedores SET ?", {
      idproveedor,
      idtipo_documento,
      documento,
      razonsocial,
      nombres,
      apellidos,
      direccion,
      telefono,
      correo,
      idusuario,
      idregimen,
      fechacreacion,
    });

    if (datos.affectedRows > 0) {
      datos = await pool.query("SELECT * FROM tarifasiva");
      res.status(200).send(datos);
    } else res.status(201).send({ mensaje: "No Se Actualizo El Campo" });
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
  consultar,
  consultarParametros,
  editar,
  crear,
  error,
};
