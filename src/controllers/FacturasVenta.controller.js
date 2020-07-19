const pool = require("../config/database");

async function crear(req, res) {
  res.setHeader("Content-Type", "application/json");
  const { idcliente, numero, prefijo, articulos } = req.body;
  const { idusuario } = req;
  const fechacreacion = new Date();

  try {
    let datos = await pool.query("INSERT INTO facturas_venta SET ?", {
      idcliente,
      idusuario,
      numero,
      prefijo,
      fechacreacion,
    });

    if (datos.affectedRows > 0) {
      const idfactura_venta = datos.insertId;
      articulos.forEach(async (articulo) => {
        datos = await pool.query(
          "INSERT INTO factura_venta_detalles (codigoarticulo,descripcionarticulo," +
            "cantidadarticulo,valorarticulo,ivaarticulo,idtarifaiva,idfactura_venta)" +
            "values(?,?,?,?,?,?,?)",
          [
            articulo.codigoarticulo,
            articulo.descripcionarticulo,
            articulo.cantidadarticulo,
            parseFloat(articulo.valorarticulo),
            parseFloat(articulo.ivaarticulo) / articulo.cantidadarticulo,
            articulo.idtarifaiva,
            idfactura_venta,
          ]
        );
      });

      if (datos.affectedRows > 0) {
        res.status(200).send({
          mensaje: "Factura Creada Correctamente No. " + idfactura_venta,
        });
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
  crear,
  error,
};
