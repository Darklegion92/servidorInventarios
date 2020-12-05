const pool = require('../config/database')
const Services = require('../services')

async function consultartarifasiva (req, res) {
  res.setHeader('Content-Type', 'application/json')

  try {
    const datos = await pool.query('SELECT * FROM tarifasiva')

    if (datos.length > 0) {
      res.status(200).send(datos)
    } else res.status(201).send({ mensaje: 'No Se Encontraron Resultados' })
  } catch (e) {
    res.status(501).send({ mensaje: 'Error ' + e })
    console.log(e)
  }
}

async function consultarucursales (req, res) {
  res.setHeader('Content-Type', 'application/json')

  try {
    const datos = await pool.query('SELECT * FROM sucursales')
    if (datos.length > 0) {
      res.status(200).send(datos)
    } else res.status(201).send({ mensaje: 'No Se Encontraron Resultados' })
  } catch (e) {
    res.status(501).send({ mensaje: 'Error ' + e })
    console.log(e)
  }
}

async function informesFacturacion (req, res) {
  res.setHeader('Content-Type', 'application/json')

  try {
    const datosTipos = await pool.query(
      "SELECT * FROM tipos_informe where modulo='FACTURACION'"
    )
    if (datosTipos.length > 0) {
      const datosGrupos = await pool.query('SELECT * FROM grupos')
      if (datosGrupos.length > 0) {
        res.status(200).send({
          datosTipos,
          datosGrupos
        })
      } else res.status(201).send({ mensaje: 'No Se Encontraron Resultados' })
    }
  } catch (e) {
    res.status(501).send({ mensaje: 'Error ' + e })
    console.log(e)
  }
}

async function consultarnumeroorden (req, res) {
  res.setHeader('Content-Type', 'application/json')

  try {
    const datos = await pool.query(
      'SELECT max(idorden_compra) as numero FROM ordenes_compra'
    )

    if (datos.length > 0) {
      res.status(200).send({ numero: datos[0].numero })
    } else res.status(201).send({ mensaje: 'No Se Encontraron Resultados' })
  } catch (e) {
    res.status(501).send({ mensaje: 'Error ' + e })
    console.log(e)
  }
}

async function consultarbodegas (req, res) {
  res.setHeader('Content-Type', 'application/json')
  try {
    const { idsucursal } = req.params

    let sql =
      'SELECT b.*, s.nombre as nombresucursal FROM bodegas b, sucursales s where b.idsucursal = s.id '

    if (idsucursal) {
      sql =
        'SELECT b.*, s.nombre as nombresucursal FROM bodegas b, sucursales s where b.idsucursal = s.id AND idsucursal=' +
        idsucursal
    }
    const datos = await pool.query(sql)

    if (datos.length > 0) {
      res.status(200).send(datos)
    } else res.status(201).send({ mensaje: 'No Se Encontraron Resultados' })
  } catch (e) {
    res.status(501).send({ mensaje: 'Error ' + e })
    console.log(e)
  }
}

async function consultarnumerofacturacompra (req, res) {
  res.setHeader('Content-Type', 'application/json')

  try {
    const datos = await pool.query(
      'SELECT max(idfactura_compra) as numero FROM facturas_compra'
    )

    if (datos.length > 0) {
      res.status(200).send({ numero: datos[0].numero })
    } else res.status(201).send({ mensaje: 'No Se Encontraron Resultados' })
  } catch (e) {
    res.status(501).send({ mensaje: 'Error ' + e })
    console.log(e)
  }
}

async function consultarnumerofacturaventa (req, res) {
  res.setHeader('Content-Type', 'application/json')

  const { idsucursal } = req.params

  try {
    const datos = await pool.query(
      'SELECT * FROM numeracion where idsucursal=?',
      [idsucursal]
    )

    if (datos.length > 0) {
      res.status(200).send(datos[0])
    } else res.status(201).send({ mensaje: 'No Se Encontraron Resultados' })
  } catch (e) {
    console.log(e)
    res.status(501).send({ mensaje: 'Error ' + e })
  }
}

async function consultarlistasprecios (req, res) {
  res.setHeader('Content-Type', 'application/json')

  try {
    const datos = await pool.query('SELECT * FROM listasprecios')

    if (datos.length > 0) {
      res.status(200).send(datos)
    } else res.status(201).send({ mensaje: 'No Se Encontraron Resultados' })
  } catch (e) {
    res.status(501).send({ mensaje: 'Error ' + e })
    console.log(e)
  }
}

async function consultarnumeracion (req, res) {
  res.setHeader('Content-Type', 'application/json')

  try {
    const datos = await pool.query(
      'SELECT n.*, s.nombre as nombresucursal FROM numeracion n, sucursales s where n.idsucursal = s.id '
    )

    if (datos.length > 0) {
      res.status(200).send(datos)
    } else res.status(201).send({ mensaje: 'No Se Encontraron Resultados' })
  } catch (e) {
    res.status(501).send({ mensaje: 'Error ' + e })
    console.log(e)
  }
}

async function consultarregimenes (req, res) {
  res.setHeader('Content-Type', 'application/json')

  try {
    const datos = await pool.query('SELECT * FROM regimenes')

    if (datos.length > 0) {
      res.status(200).send(datos)
    } else res.status(201).send({ mensaje: 'No Se Encontraron Resultados' })
  } catch (e) {
    res.status(501).send({ mensaje: 'Error ' + e })
    console.log(e)
  }
}

async function consultartiposdocumento (req, res) {
  res.setHeader('Content-Type', 'application/json')

  try {
    const datos = await pool.query('SELECT * FROM tipos_documento')

    if (datos.length > 0) {
      res.status(200).send(datos)
    } else res.status(201).send({ mensaje: 'No Se Encontraron Resultados' })
  } catch (e) {
    res.status(501).send({ mensaje: 'Error ' + e })
    console.log(e)
  }
}

async function editartarifasiva (req, res) {
  res.setHeader('Content-Type', 'application/json')
  const { nombre, tarifa, idtarifaiva } = req.body

  try {
    let datos = await pool.query(
      'UPDATE tarifasiva SET nombre=?, tarifa=? WHERE idtarifaiva=?',
      [nombre, tarifa, idtarifaiva]
    )

    if (datos.affectedRows > 0) {
      datos = await pool.query('SELECT * FROM tarifasiva')
      res.status(200).send(datos)
    } else res.status(201).send({ mensaje: 'No Se Actualizo El Campo' })
  } catch (e) {
    res.status(501).send({ mensaje: 'Error ' + e })
    console.log(e)
  }
}

async function editarbodega (req, res) {
  res.setHeader('Content-Type', 'application/json')
  const { nombre, id, idsucursal } = req.body
  try {
    let datos = await pool.query(
      'UPDATE bodegas SET nombre=?,idsucursal=? WHERE id=?',
      [nombre, idsucursal, id]
    )

    if (datos.affectedRows > 0) {
      datos = await pool.query(
        'SELECT b.*, s.nombre as nombresucursal FROM bodegas b, sucursales s where b.idsucursal = s.id '
      )
      res.status(200).send(datos)
    } else res.status(201).send({ mensaje: 'No Se Actualizo El Campo' })
  } catch (e) {
    res.status(501).send({ mensaje: 'Error ' + e })
    console.log(e)
  }
}

async function editarsucursal (req, res) {
  res.setHeader('Content-Type', 'application/json')
  const { nombre, id } = req.body
  try {
    let datos = await pool.query('UPDATE sucursales SET nombre=? WHERE id=?', [
      nombre,
      id
    ])

    if (datos.affectedRows > 0) {
      datos = await pool.query('SELECT  * from sucursales')
      res.status(200).send(datos)
    } else res.status(201).send({ mensaje: 'No Se Actualizo El Campo' })
  } catch (e) {
    res.status(501).send({ mensaje: 'Error ' + e })
    console.log(e)
  }
}

async function editarlistasprecios (req, res) {
  res.setHeader('Content-Type', 'application/json')
  const { nombre, idlistaprecios } = req.body

  try {
    let datos = await pool.query(
      'UPDATE listasprecios SET nombre=? WHERE idlistaprecios=?',
      [nombre, idlistaprecios]
    )

    if (datos.affectedRows > 0) {
      datos = await pool.query('SELECT * FROM listasprecios')
      res.status(200).send(datos)
    } else res.status(201).send({ mensaje: 'No Se Actualizo El Campo' })
  } catch (e) {
    res.status(501).send({ mensaje: 'Error ' + e })
    console.log(e)
  }
}

async function editarnumeracion (req, res) {
  res.setHeader('Content-Type', 'application/json')
  const {
    prefijo,
    numero,
    autorizacion,
    fechaautorizacion,
    fechavencimiento,
    extension,
    idnumeracion,
    idsucursal
  } = req.body

  try {
    let datos = await pool.query(
      'UPDATE numeracion SET prefijo=?,numero=?,autorizacion=?,fechaautorizacion=?, fechavencimiento=?,' +
        'extension=?,idsucursal=? WHERE idnumeracion=?',
      [
        prefijo,
        numero,
        autorizacion,
        fechaautorizacion,
        fechavencimiento,
        1,
        idsucursal,
        idnumeracion
      ]
    )

    if (datos.affectedRows > 0) {
      datos = await pool.query('SELECT * FROM numeracion')
      res.status(200).send(datos)
    } else res.status(201).send({ mensaje: 'No Se Actualizo El Campo' })
  } catch (e) {
    res.status(501).send({ mensaje: 'Error ' + e })
    console.log(e)
  }
}

async function creartarifasiva (req, res) {
  res.setHeader('Content-Type', 'application/json')
  const { nombre, tarifa } = req.body
  const { idusuario } = req
  const fechacreacion = new Date()

  try {
    let datos = await pool.query('INSERT INTO tarifasiva SET ?', {
      nombre,
      tarifa,
      idusuario,
      fechacreacion
    })

    if (datos.affectedRows > 0) {
      datos = await pool.query('SELECT * FROM tarifasiva')
      res.status(200).send(datos)
    } else res.status(201).send({ mensaje: 'No Se Actualizo El Campo' })
  } catch (e) {
    res.status(501).send({ mensaje: 'Error ' + e })
    console.log(e)
  }
}

async function crearbodega (req, res) {
  res.setHeader('Content-Type', 'application/json')
  const { nombre, idsucursal } = req.body
  const { idusuario } = req
  const fechacreacion = new Date()

  try {
    let datos = await pool.query('INSERT INTO bodegas SET ?', {
      nombre,
      idsucursal,
      idusuario,
      fechacreacion
    })

    if (datos.affectedRows > 0) {
      datos = await pool.query(
        'SELECT b.*, s.nombre as nombresucursal FROM bodegas b, sucursales s where b.idsucursal = s.id '
      )
      res.status(200).send(datos)
    } else res.status(201).send({ mensaje: 'No Se Actualizo El Campo' })
  } catch (e) {
    res.status(501).send({ mensaje: 'Error ' + e })
    console.log(e)
  }
}

async function crearsucursal (req, res) {
  res.setHeader('Content-Type', 'application/json')
  const { nombre } = req.body
  const fechacreacion = new Date()

  try {
    let datos = await pool.query('INSERT INTO sucursales SET ?', {
      nombre,
      fechacreacion
    })

    if (datos.affectedRows > 0) {
      datos = await pool.query('SELECT * from sucursales ')
      res.status(200).send(datos)
    } else res.status(201).send({ mensaje: 'No Se Creo La Sucursal' })
  } catch (e) {
    res.status(501).send({ mensaje: 'Error ' + e })
    console.log(e)
  }
}

async function crearlistasprecios (req, res) {
  res.setHeader('Content-Type', 'application/json')
  const { nombre } = req.body
  const { idusuario } = req
  const fechacreacion = new Date()

  try {
    let datos = await pool.query('INSERT INTO listasprecios SET ?', {
      nombre,
      idusuario,
      fechacreacion
    })

    if (datos.affectedRows > 0) {
      datos = await pool.query('SELECT * FROM listasprecios')
      res.status(200).send(datos)
    } else res.status(201).send({ mensaje: 'No Se Actualizo El Campo' })
  } catch (e) {
    res.status(501).send({ mensaje: 'Error ' + e })
    console.log(e)
  }
}

async function crearnumeracion (req, res) {
  res.setHeader('Content-Type', 'application/json')
  const {
    prefijo,
    numero,
    autorizacion,
    fechaautorizacion,
    fechavencimiento,
    extension,
    idsucursal
  } = req.body
  const { idusuario } = req
  const fechacreacion = new Date()

  try {
    let datos = await pool.query('INSERT INTO numeracion SET ?', {
      prefijo,
      numero,
      autorizacion,
      fechaautorizacion,
      fechavencimiento,
      extension: 1,
      fechacreacion,
      idusuario,
      idsucursal
    })

    if (datos.affectedRows > 0) {
      datos = await pool.query(
        'SELECT n.*, s.nombre as nombresucursal FROM numeracion n, sucursales s where s.id=n.idsucursal'
      )
      res.status(200).send(datos)
    } else res.status(201).send({ mensaje: 'No Se Actualizo El Campo' })
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
  consultarnumeracion,
  consultarucursales,
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
  editarbodega,
  crearbodega,
  crearsucursal,
  editarsucursal,
  error
}
