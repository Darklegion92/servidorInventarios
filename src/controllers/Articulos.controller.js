const pool = require("../config/database");

async function consultar(req, res) {
  res.setHeader("Content-Type", "application/json");

  try {
    const datos = await pool.query(
      "SELECT a.*, g.nombre as nombregrupo,s.nombre as nombresubgrupo, m.nombre as nombremarca, t.nombre as nombreTarifa,p.valor " +
        "FROM articulos a, grupos g, subgrupos s, marcas m, tarifasiva t,precios p " +
        "WHERE a.idgrupo = g.idgrupo AND s.idgrupo = a.idgrupo AND s.idsubgrupo = a.idsubgrupo AND m.idmarca = a.idmarca AND " +
        "t.idtarifaiva = a.idtarifaiva AND a.idarticulo = p.idarticulo AND p.idlistaprecios = 1"
    );

    if (datos.length > 0) {
      res.status(200).send(datos);
    } else res.status(201).send({ mensaje: "No Se Encontraron Resultados" });
  } catch (e) {
    res.status(501).send({ mensaje: "Error " + e });
    console.log(e);
  }
}

async function consultarPrecios(req, res) {
  res.setHeader("Content-Type", "application/json");

  const { id } = req.params;
  try {
    const datos = await pool.query(
      "SELECT p.*, l.nombre as nombre FROM precios p, listasprecios l " +
        "WHERE p.idlistaprecios = l.idlistaprecios AND idarticulo=?",
      [id]
    );

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
    descripcion,
    codigo,
    idtarifaiva,
    idgrupo,
    idsubgrupo,
    idmarca,
    estado,
    precios,
    idarticulo,
  } = req.body;

  try {
    let datos = await pool.query(
      "UPDATE aritulos SET idtipo_documento=?, documento=?,razonsocial=?, nombres=?,apellidos=?," +
        "direccion=?,telefono=?,correo=?,idregimen=? WHERE idproveedor=?",
      [
        descripcion,
        codigo,
        idtarifaiva,
        idgrupo,
        idsubgrupo,
        idmarca,
        estado,
        idarticulo,
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
    descripcion,
    codigo,
    idtarifaiva,
    idgrupo,
    idsubgrupo,
    idmarca,
    estado,
    precios,
  } = req.body;

  const { idusuario } = req;
  const fechacreacion = new Date();

  try {
    let datos = await pool.query("INSERT INTO articulos SET ?", {
      descripcion,
      codigo,
      idtarifaiva,
      idgrupo,
      idsubgrupo,
      idmarca,
      estado,
      idusuario,
      fechacreacion,
    });

    if (datos.affectedRows > 0) {
      const idarticulo = datos.insertId;
      precios.map(async (precio) => {
        datos = await pool.query(
          "INSERT INTO precios (idusuario,fechacreacion,valor,idlistaprecios,idarticulo)" +
            "values(?,?,?,?,?)",
          [idusuario, fechacreacion, precio.valor, precio.id, idarticulo]
        );
      });
      if (datos.affectedRows > 0) {
        datos = await pool.query(
          "SELECT a.*, g.nombre as nombregrupo,s.nombre as nombresubgrupo, m.nombre as nombremarca, t.nombre as nombreTarifa,p.valor " +
            "FROM articulos a, grupos g, subgrupos s, marcas m, tarifasiva t,precios p " +
            "WHERE a.idgrupo = g.idgrupo AND s.idgrupo = a.idgrupo AND s.idsubgrupo = a.idsubgrupo AND m.idmarca = a.idmarca AND " +
            "t.idtarifaiva = a.idtarifaiva AND a.idarticulo = p.idarticulo AND p.idlistaprecios = 1"
        );
        res.status(200).send(datos);
      }
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
  editar,
  crear,
  consultarPrecios,
  error,
};
