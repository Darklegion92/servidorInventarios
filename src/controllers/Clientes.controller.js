const pool = require("../config/database");

async function consultar(req, res) {
  res.setHeader("Content-Type", "application/json");

  try {
    const datos = await pool.query(
      "SELECT c.*, t.prefijo,c.documento, l.nombre FROM clientes c, tipos_documento t, listasprecios l WHERE t.idtipo_documento = c.idtipo_documento " +
        "AND l.idlistaprecios= c.idlistaprecios"
    );

    if (datos.length > 0) {
      res.status(200).send(datos);
    } else res.status(201).send({ mensaje: "No Se Encontraron Resultados" });
  } catch (e) {
    res.status(501).send({ mensaje: "Error " + e });
    console.log(e);
  }
}

async function consultarDocumento(req, res) {
  res.setHeader("Content-Type", "application/json");

  const { documento } = req.params;

  try {
    const datos = await pool.query(
      "SELECT c.*, t.prefijo, l.nombre FROM listasprecios l,clientes c, tipos_documento t WHERE t.idtipo_documento = c.idtipo_documento " +
        "AND c.idlistaprecios= l.idlistaprecios AND c.documento='" +
        documento +
        "'"
    );

    if (datos.length > 0) {
      res.status(200).send(datos[0]);
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
      "SELECT c.*, t.prefijo, l.nombre FROM clientes c, tipos_documento t,listasprecios l WHERE t.idtipo_documento = c.idtipo_documento " +
      "AND l.idlistaprecios= c.idlistaprecios AND c.documento like '%" +
      dato +
      "%'";
  }

  if (tipo === "nombre") {
    sql =
      "SELECT c.*, t.prefijo, l.nombre FROM clientes c, tipos_documento t,listasprecios l WHERE t.idtipo_documento = c.idtipo_documento " +
      "AND l.idlistaprecios= c.idlistaprecios AND (c.nombres like '%" +
      dato +
      "%' OR c.apellidos like '%" +
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
    idcliente,
    idtipo_documento,
    documento,
    nombres,
    apellidos,
    direccion,
    telefono,
    idlistaprecios,
  } = req.body;
  console.log(idlistaprecios);
  try {
    let datos = await pool.query(
      "UPDATE clientes SET idtipo_documento=?, documento=?,nombres=?,apellidos=?," +
        "direccion=?,telefono=?,idlistaprecios=? WHERE idcliente=?",
      [
        idtipo_documento,
        documento,
        nombres,
        apellidos,
        direccion,
        telefono,
        idlistaprecios,
        idcliente,
      ]
    );

    if (datos.affectedRows > 0) {
      datos = await pool.query("SELECT * FROM clientes");
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
    idtipo_documento,
    documento,
    nombres,
    apellidos,
    direccion,
    telefono,
    idlistaprecios,
  } = req.body;

  const { idusuario } = req;
  const fechacreacion = new Date();

  try {
    let datos = await pool.query("INSERT INTO clientes SET ?", {
      idtipo_documento,
      documento,
      nombres,
      apellidos,
      direccion,
      telefono,
      idlistaprecios,
      idusuario,
      fechacreacion,
    });

    if (datos.affectedRows > 0) {
      datos = await pool.query("SELECT * FROM clientes");
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
  consultarDocumento,
  editar,
  crear,
  error,
};
