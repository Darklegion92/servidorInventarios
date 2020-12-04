const pool = require('../config/database')

async function crear (req, res) {
  res.setHeader('Content-Type', 'application/json')
  const { articulos, idbodega, observacion } = req.body
  const { idusuario } = req
  const fechacreacion = new Date()
  try {
    let datos = await pool.query('INSERT INTO entradas SET ?', {
      idusuario,
      fechacreacion,
      observacion,
      estado: 1
    })

    if (datos.affectedRows > 0) {
      const identrada = datos.insertId
      articulos.forEach(async articulo => {
        datos = await pool.query(
          'INSERT INTO entradas_detalle (codigoarticulo,descripcionarticulo,' +
            'cantidadarticulo,valorarticulo,ivaarticulo,idtarifaiva,identrada,idbodega)' +
            'value(?,?,?,?,?,(select idtarifaiva from articulos where codigo=?),?,?)',
          [
            articulo.codigoarticulo,
            articulo.descripcionarticulo,
            articulo.cantidadarticulo,
            parseFloat(articulo.valorarticulo),
            0,
            articulo.codigoarticulo,
            identrada,
            idbodega
          ]
        )
      })

      if (datos.affectedRows > 0) {
        res.status(200).send({
          mensaje: 'Factura Creada Correctamente No. ' + identrada
        })
      }
    } else res.status(201).send({ mensaje: 'No Se Actualizo El Campo' })
  } catch (e) {
    console.log(e)
    res.status(501).send({ mensaje: 'Error ' + e })
  }
}

async function devoluciones (req, res) {
  res.setHeader('Content-Type', 'application/json')
  const { articulos } = req.body
  const { idusuario } = req
  const fechacreacion = new Date()
  let datos
  try {
    await articulos.forEach(async articulo => {
      const idfactura_venta_detalle = articulo
      datos = await pool.query('INSERT INTO devoluciones_ventas SET ?', {
        idfactura_venta_detalle,
        idusuario,
        fechacreacion
      })
    })
    res.status(200).send({
      mensaje: 'Se han devuelto los artículos'
    })
  } catch (e) {
    res.status(501).send({ mensaje: 'Error ' + e })
  }
}

async function consultarNumero (req, res) {
  res.setHeader('Content-Type', 'application/json')
  const { numero } = req.params

  try {
    const datos = await pool.query(
      "SELECT f.*, concat(c.nombres,' ',c.apellidos) AS nombre, c.documento FROM facturas_venta f, clientes c " +
        'WHERE c.idcliente = f.idcliente AND iddevolucion_ventas is null AND  ?',
      {
        numero
      }
    )

    if (datos[0]) {
      const articulos = await pool.query(
        'SELECT *, cantidadarticulo * valorarticulo as total FROM factura_venta_detalles d WHERE idfactura_venta = ?',
        datos[0].idfactura_venta
      )
      let data = datos[0]
      data.articulos = articulos
      res.status(200).send(data)
    } else res.status(201).send({ mensaje: 'No Se Encontraron Valores' })
  } catch (e) {
    res.status(501).send({ mensaje: 'Error ' + e })
    console.log(e)
  }
}

async function ventasDia (req, res) {
  res.setHeader('Content-Type', 'application/json')

  try {
    const datos = await pool.query(
      'SELECT SUM(d.cantidadarticulo*d.valorarticulo) as total FROM factura_venta_detalles d, facturas_venta f ' +
        'WHERE f.idfactura_venta = d.idfactura_venta AND f.fechacreacion>=CURDATE()'
    )
    console.log(datos)
    if (datos[0]) {
      res.status(200).send(datos)
    } else res.status(201).send({ mensaje: 'No Se Encontraron Valores' })
  } catch (e) {
    res.status(501).send({ mensaje: 'Error ' + e })
    console.log(e)
  }
}

function error (req, res) {
  res.setHeader('Content-Type', 'application/json')
  res.status(404).send({ mensaje: 'Página no encontrada' })
}

module.exports = {
  crear,
  consultarNumero,
  devoluciones,
  ventasDia,
  error
}
