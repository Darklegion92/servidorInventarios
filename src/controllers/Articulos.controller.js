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

async function consultarOrden(req, res) {
  res.setHeader("Content-Type", "application/json");
  const { tipo, dato } = req.params;

  try {
    let sql;
    if (tipo === "codigo") {
      sql =
        "SELECT a.*, t.tarifa as tarifa FROM articulos a, tarifasiva t " +
        "WHERE t.idtarifaiva = a.idtarifaiva AND a.codigo = '" +
        dato +
        "'";
    } else {
      sql =
        "SELECT a.*, t.tarifa as tarifa FROM articulos a, tarifasiva t " +
        "WHERE t.idtarifaiva = a.idtarifaiva AND a.descripcion LIKE '%" +
        dato +
        "%'";
    }
    const datos = await pool.query(sql);

    if (datos.length > 0) {
      res.status(200).send(datos);
    } else res.status(201).send({ mensaje: "No Se Encontraron Resultados" });
  } catch (e) {
    res.status(501).send({ mensaje: "Error " + e });
    console.log(e);
  }
}

async function consultarVentas(req, res) {
  res.setHeader("Content-Type", "application/json");
  const { tipo, dato, idlistaprecios } = req.params;

  try {
    let sql;
    if (tipo === "codigo") {
      sql =
        "SELECT a.*, t.tarifa as tarifa,p.valor as valor FROM articulos a, tarifasiva t, precios p " +
        "WHERE t.idtarifaiva = a.idtarifaiva AND p.idarticulo = a.idarticulo AND p.idlistaprecios = " +
        idlistaprecios +
        " AND a.codigo = '" +
        dato +
        "'";
    } else {
      sql =
        "SELECT a.*, t.tarifa as tarifa,p.valor as valor FROM articulos a, tarifasiva t, precios p " +
        "WHERE t.idtarifaiva = a.idtarifaiva AND p.idarticulo = a.idarticulo AND p.idlistaprecios = " +
        idlistaprecios +
        " AND a.descripcion LIKE '%" +
        dato +
        "%'";
    }
    const datos = await pool.query(sql);
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
  console.log(req.params);
  try {
    let sql;
    if (tipo === "codigo") {
      sql =
        "SELECT a.*, g.nombre as nombregrupo,s.nombre as nombresubgrupo, m.nombre as nombremarca, t.nombre as nombreTarifa,p.valor " +
        "FROM articulos a, grupos g, subgrupos s, marcas m, tarifasiva t,precios p " +
        "WHERE a.idgrupo = g.idgrupo AND s.idgrupo = a.idgrupo AND s.idsubgrupo = a.idsubgrupo AND m.idmarca = a.idmarca AND " +
        "t.idtarifaiva = a.idtarifaiva AND a.idarticulo = p.idarticulo AND p.idlistaprecios = 1 AND a.codigo LIKE'%" +
        dato +
        "%'";
    }

    if (tipo === "descripcion") {
      sql =
        "SELECT a.*, g.nombre as nombregrupo,s.nombre as nombresubgrupo, m.nombre as nombremarca, t.nombre as nombreTarifa,p.valor " +
        "FROM articulos a, grupos g, subgrupos s, marcas m, tarifasiva t,precios p " +
        "WHERE a.idgrupo = g.idgrupo AND s.idgrupo = a.idgrupo AND s.idsubgrupo = a.idsubgrupo AND m.idmarca = a.idmarca AND " +
        "t.idtarifaiva = a.idtarifaiva AND a.idarticulo = p.idarticulo AND p.idlistaprecios = 1 AND a.descripcion LIKE '%" +
        dato +
        "%'";
    }

    const datos = await pool.query(sql);
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

  const { idusuario } = req;
  const fechacreacion = new Date();

  try {
    let datos = await pool.query(
      "UPDATE articulos SET descripcion=?, codigo=?,idtarifaiva=?, idgrupo=?,idsubgrupo=?,idmarca=?," +
        "estado=? WHERE idarticulo=?",
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
      await precios.map(async (precio) => {
        if (precio.editado) {
          datos = await pool.query(
            "UPDATE precios SET valor=?, idusuario=?, fechacreacion=? WHERE idprecio=?",
            [precio.valor, idusuario, fechacreacion, precio.id]
          );
        } else {
          datos = await pool.query("INSERT INTO precios VALUES ?", {
            idlistaprecios: precio.id,
            valor: precio.valor,
            idarticulo: idarticulo,
            idusuario: idusuario,
            fechacreacion: fechacreacion,
          });
        }
      });
      if (datos.affectedRows > 0) {
        datos = await pool.query(
          "SELECT a.*, g.nombre as nombregrupo,s.nombre as nombresubgrupo, m.nombre as nombremarca, t.nombre as nombreTarifa,p.valor " +
            "FROM articulos a, grupos g, subgrupos s, marcas m, tarifasiva t,precios p " +
            "WHERE a.idgrupo = g.idgrupo AND s.idgrupo = a.idgrupo AND s.idsubgrupo = a.idsubgrupo AND m.idmarca = a.idmarca AND " +
            "t.idtarifaiva = a.idtarifaiva AND a.idarticulo = p.idarticulo AND p.idlistaprecios = 1"
        );
        res.status(200).send(datos);
      } else res.status(201).send({ mensaje: "No Se Actualizo Precios" });
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
  consultarParametros,
  editar,
  crear,
  consultarPrecios,
  consultarOrden,
  consultarVentas,
  error,
};
