const pool = require("../config/database");
const Services = require("../services");

async function consultartarifasiva(req, res) {
  res.setHeader("Content-Type", "application/json");

  try {
    const datos = await pool.query("SELECT * FROM tarifasiva");

    if (datos.length > 0) {
      res.status(200).send(datos);
    } else res.status(201).send({ mensaje: "No Se Encontraron Resultados" });
  } catch (e) {
    res.status(501).send({ mensaje: "Error " + e });
    console.log(e);
  }
}

async function informesFacturacion(req, res) {
  res.setHeader("Content-Type", "application/json");

  try {
    const datosTipos = await pool.query(
      "SELECT * FROM tipos_informe where modulo='FACTURACION'"
    );
    if (datosTipos.length > 0) {
      const datosGrupos = await pool.query("SELECT * FROM grupos");
      if (datosGrupos.length > 0) {
        res.status(200).send({
          datosTipos,
          datosGrupos,
        });
      } else res.status(201).send({ mensaje: "No Se Encontraron Resultados" });
    }
  } catch (e) {
    res.status(501).send({ mensaje: "Error " + e });
    console.log(e);
  }
}

async function consultarnumeroorden(req, res) {
  res.setHeader("Content-Type", "application/json");

  try {
    const datos = await pool.query(
      "SELECT max(idorden_compra) as numero FROM ordenes_compra"
    );

    if (datos.length > 0) {
      res.status(200).send({ numero: datos[0].numero });
    } else res.status(201).send({ mensaje: "No Se Encontraron Resultados" });
  } catch (e) {
    res.status(501).send({ mensaje: "Error " + e });
    console.log(e);
  }
}

async function consultarbodegas(req, res) {
  res.setHeader("Content-Type", "application/json");
  try {
    const { idsucursal } = req.params;

    let sql = "SELECT * FROM bodegas order by estado";

    if (idsucursal) {
      sql =
        "SELECT * FROM bodegas WHERE idsucursal=" +
        idsucursal +
        " order by estado";
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

async function consultarnumerofacturacompra(req, res) {
  res.setHeader("Content-Type", "application/json");

  try {
    const datos = await pool.query(
      "SELECT max(idfactura_compra) as numero FROM facturas_compra"
    );

    if (datos.length > 0) {
      res.status(200).send({ numero: datos[0].numero });
    } else res.status(201).send({ mensaje: "No Se Encontraron Resultados" });
  } catch (e) {
    res.status(501).send({ mensaje: "Error " + e });
    console.log(e);
  }
}

async function consultarnumerofacturaventa(req, res) {
  res.setHeader("Content-Type", "application/json");

  try {
    const datos = await pool.query("SELECT * FROM numeracion");
    if (datos.length > 0) {
      res.status(200).send(datos[0]);
    } else res.status(201).send({ mensaje: "No Se Encontraron Resultados" });
  } catch (e) {
    console.log(e);
    res.status(501).send({ mensaje: "Error " + e });
  }
}

async function consultarlistasprecios(req, res) {
  res.setHeader("Content-Type", "application/json");

  try {
    const datos = await pool.query("SELECT * FROM listasprecios");

    if (datos.length > 0) {
      res.status(200).send(datos);
    } else res.status(201).send({ mensaje: "No Se Encontraron Resultados" });
  } catch (e) {
    res.status(501).send({ mensaje: "Error " + e });
    console.log(e);
  }
}

async function consultarnumeracion(req, res) {
  res.setHeader("Content-Type", "application/json");

  try {
    const datos = await pool.query("SELECT * FROM numeracion");

    if (datos.length > 0) {
      res.status(200).send(datos);
    } else res.status(201).send({ mensaje: "No Se Encontraron Resultados" });
  } catch (e) {
    res.status(501).send({ mensaje: "Error " + e });
    console.log(e);
  }
}

async function consultarregimenes(req, res) {
  res.setHeader("Content-Type", "application/json");

  try {
    const datos = await pool.query("SELECT * FROM regimenes");

    if (datos.length > 0) {
      res.status(200).send(datos);
    } else res.status(201).send({ mensaje: "No Se Encontraron Resultados" });
  } catch (e) {
    res.status(501).send({ mensaje: "Error " + e });
    console.log(e);
  }
}

async function consultartiposdocumento(req, res) {
  res.setHeader("Content-Type", "application/json");

  try {
    const datos = await pool.query("SELECT * FROM tipos_documento");

    if (datos.length > 0) {
      res.status(200).send(datos);
    } else res.status(201).send({ mensaje: "No Se Encontraron Resultados" });
  } catch (e) {
    res.status(501).send({ mensaje: "Error " + e });
    console.log(e);
  }
}

async function editartarifasiva(req, res) {
  res.setHeader("Content-Type", "application/json");
  const { nombre, tarifa, idtarifaiva } = req.body;

  try {
    let datos = await pool.query(
      "UPDATE tarifasiva SET nombre=?, tarifa=? WHERE idtarifaiva=?",
      [nombre, tarifa, idtarifaiva]
    );

    if (datos.affectedRows > 0) {
      datos = await pool.query("SELECT * FROM tarifasiva");
      res.status(200).send(datos);
    } else res.status(201).send({ mensaje: "No Se Actualizo El Campo" });
  } catch (e) {
    res.status(501).send({ mensaje: "Error " + e });
    console.log(e);
  }
}

async function editarlistasprecios(req, res) {
  res.setHeader("Content-Type", "application/json");
  const { nombre, idlistaprecios } = req.body;

  try {
    let datos = await pool.query(
      "UPDATE listasprecios SET nombre=? WHERE idlistaprecios=?",
      [nombre, idlistaprecios]
    );

    if (datos.affectedRows > 0) {
      datos = await pool.query("SELECT * FROM listasprecios");
      res.status(200).send(datos);
    } else res.status(201).send({ mensaje: "No Se Actualizo El Campo" });
  } catch (e) {
    res.status(501).send({ mensaje: "Error " + e });
    console.log(e);
  }
}

async function editarnumeracion(req, res) {
  res.setHeader("Content-Type", "application/json");
  const {
    prefijo,
    numero,
    autorizacion,
    fechaautorizacion,
    fechavencimiento,
    extension,
    idnumeracion,
  } = req.body;

  try {
    let datos = await pool.query(
      "UPDATE numeracion SET prefijo=?,numero=?,autorizacion=?,fechaautorizacion=?, fechavencimiento=?," +
        "extension=? WHERE idnumeracion=?",
      [
        prefijo,
        numero,
        autorizacion,
        fechaautorizacion,
        fechavencimiento,
        extension,
        idnumeracion,
      ]
    );

    if (datos.affectedRows > 0) {
      datos = await pool.query("SELECT * FROM numeracion");
      res.status(200).send(datos);
    } else res.status(201).send({ mensaje: "No Se Actualizo El Campo" });
  } catch (e) {
    res.status(501).send({ mensaje: "Error " + e });
    console.log(e);
  }
}

async function creartarifasiva(req, res) {
  res.setHeader("Content-Type", "application/json");
  const { nombre, tarifa } = req.body;
  const { idusuario } = req;
  const fechacreacion = new Date();

  try {
    let datos = await pool.query("INSERT INTO tarifasiva SET ?", {
      nombre,
      tarifa,
      idusuario,
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

async function crearlistasprecios(req, res) {
  res.setHeader("Content-Type", "application/json");
  const { nombre } = req.body;
  const { idusuario } = req;
  const fechacreacion = new Date();

  try {
    let datos = await pool.query("INSERT INTO listasprecios SET ?", {
      nombre,
      idusuario,
      fechacreacion,
    });

    if (datos.affectedRows > 0) {
      datos = await pool.query("SELECT * FROM listasprecios");
      res.status(200).send(datos);
    } else res.status(201).send({ mensaje: "No Se Actualizo El Campo" });
  } catch (e) {
    res.status(501).send({ mensaje: "Error " + e });
    console.log(e);
  }
}

async function crearnumeracion(req, res) {
  res.setHeader("Content-Type", "application/json");
  const {
    prefijo,
    numero,
    autorizacion,
    fechaautorizacion,
    fechavencimiento,
    extension,
  } = req.body;
  const { idusuario } = req;
  const fechacreacion = new Date();

  try {
    let datos = await pool.query("INSERT INTO numeracion SET ?", {
      prefijo,
      numero,
      autorizacion,
      fechaautorizacion,
      fechavencimiento,
      extension,
      fechacreacion,
      idusuario,
    });

    if (datos.affectedRows > 0) {
      datos = await pool.query("SELECT * FROM numeracion");
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
  consultarnumeracion,
  consultarbodegas,
  consultartarifasiva,
  consultarlistasprecios,
  editarnumeracion,
  editartarifasiva,
  editarlistasprecios,
  crearnumeracion,
  creartarifasiva,
  crearlistasprecios,
  consultarregimenes,
  consultartiposdocumento,
  consultarnumeroorden,
  consultarnumerofacturacompra,
  consultarnumerofacturaventa,
  informesFacturacion,
  error,
};
