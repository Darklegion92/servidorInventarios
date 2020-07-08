const pool = require("../config/database");

async function consultargrupos(req, res) {
  res.setHeader("Content-Type", "application/json");

  try {
    const datos = await pool.query("SELECT * FROM grupos");

    if (datos.length > 0) {
      res.status(200).send(datos);
    } else res.status(201).send({ mensaje: "No Se Encontraron Resultados" });
  } catch (e) {
    res.status(501).send({ mensaje: "Error " + e });
    console.log(e);
  }
}

async function consultarsubgrupos(req, res) {
  res.setHeader("Content-Type", "application/json");

  const { id } = req.params;
  try {
    const datos = await pool.query(
      "SELECT s.*, g.nombre as nombregrupo FROM subgrupos s, grupos g WHERE g.idgrupo=s.idgrupo AND s.idgrupo=?",
      id
    );

    if (datos.length > 0) {
      res.status(200).send(datos);
    } else res.status(201).send({ mensaje: "No Se Encontraron Resultados" });
  } catch (e) {
    res.status(501).send({ mensaje: "Error " + e });
    console.log(e);
  }
}

async function consultarmarcas(req, res) {
  res.setHeader("Content-Type", "application/json");

  try {
    const datos = await pool.query("SELECT * FROM marcas");

    if (datos.length > 0) {
      res.status(200).send(datos);
    } else res.status(201).send({ mensaje: "No Se Encontraron Resultados" });
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

async function editarsubgrupos(req, res) {
  res.setHeader("Content-Type", "application/json");
  const { idsubgrupo, nombre } = req.body;

  try {
    let datos = await pool.query(
      "UPDATE subgrupos SET nombre=?   WHERE idsubgRupo=?",
      [nombre, idsubgrupo]
    );

    if (datos.affectedRows > 0) {
      datos = await pool.query("SELECT * FROM subgrupos");
      res.status(200).send(datos);
    } else res.status(201).send({ mensaje: "No Se Actualizo El Campo" });
  } catch (e) {
    res.status(501).send({ mensaje: "Error " + e });
    console.log(e);
  }
}

async function crearsubgrupos(req, res) {
  res.setHeader("Content-Type", "application/json");
  const { nombre, idgrupo } = req.body;
  const { idusuario } = req;
  const fechacreacion = new Date();

  try {
    let datos = await pool.query("INSERT INTO subgrupos SET ?", {
      nombre,
      idusuario,
      idgrupo,
      fechacreacion,
    });

    if (datos.affectedRows > 0) {
      datos = await pool.query("SELECT * FROM subgrupos");
      res.status(200).send(datos);
    } else res.status(201).send({ mensaje: "No Se Creo El Campo" });
  } catch (e) {
    res.status(501).send({ mensaje: "Error " + e });
    console.log(e);
  }
}

async function editarmarcas(req, res) {
  res.setHeader("Content-Type", "application/json");
  const { idmarca, nombre } = req.body;

  try {
    let datos = await pool.query(
      "UPDATE marcas SET nombre=?   WHERE idmarca=?",
      [nombre, idmarca]
    );

    if (datos.affectedRows > 0) {
      datos = await pool.query("SELECT * FROM marcas");
      res.status(200).send(datos);
    } else res.status(201).send({ mensaje: "No Se Actualizo El Campo" });
  } catch (e) {
    res.status(501).send({ mensaje: "Error " + e });
    console.log(e);
  }
}

async function crearmarcas(req, res) {
  res.setHeader("Content-Type", "application/json");
  const { nombre } = req.body;
  const { idusuario } = req;
  const fechacreacion = new Date();

  try {
    let datos = await pool.query("INSERT INTO marcas SET ?", {
      nombre,
      idusuario,
      fechacreacion,
    });

    if (datos.affectedRows > 0) {
      datos = await pool.query("SELECT * FROM marcas");
      res.status(200).send(datos);
    } else res.status(201).send({ mensaje: "No Se Creo El Campo" });
  } catch (e) {
    res.status(501).send({ mensaje: "Error " + e });
    console.log(e);
  }
}

async function editargrupos(req, res) {
  res.setHeader("Content-Type", "application/json");
  const { idgrupo, nombre } = req.body;

  try {
    let datos = await pool.query(
      "UPDATE grupos SET nombre=?   WHERE idgrupo=?",
      [nombre, idgrupo]
    );

    if (datos.affectedRows > 0) {
      datos = await pool.query("SELECT * FROM grupos");
      res.status(200).send(datos);
    } else res.status(201).send({ mensaje: "No Se Actualizo El Campo" });
  } catch (e) {
    res.status(501).send({ mensaje: "Error " + e });
    console.log(e);
  }
}

async function creargrupos(req, res) {
  res.setHeader("Content-Type", "application/json");
  const { nombre } = req.body;
  const { idusuario } = req;
  const fechacreacion = new Date();

  try {
    let datos = await pool.query("INSERT INTO grupos SET ?", {
      nombre,
      idusuario,
      fechacreacion,
    });

    if (datos.affectedRows > 0) {
      datos = await pool.query("SELECT * FROM grupos");
      res.status(200).send(datos);
    } else res.status(201).send({ mensaje: "No Se Creo El Campo" });
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
  consultargrupos,
  consultarsubgrupos,
  consultarmarcas,
  creargrupos,
  crearsubgrupos,
  crearmarcas,
  editargrupos,
  editarsubgrupos,
  editarmarcas,
  error,
};
