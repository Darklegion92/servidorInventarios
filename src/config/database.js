const mysql = require("mysql");
const { database } = require("./keys");
const { promisify } = require("util");

const pool = mysql.createPool(database);
pool.getConnection((err, conn) => {
  if (err) {
    if (err.code == "PROTOCOL_CONNECTION_LOST") {
      console.error("CONEXION PERDIDA CON LA DB");
    }
    if (err.code == "ER_CON_COUNT_ERROR") {
      console.error("CONEXION CON DB HA DEMORADO MUCHO TIEMPO");
    }
    if (err.code == "ECONNREFUSED") {
      console.error("CONEXION CON LA DB RECHAZADA");
    }
  }

  if (conn) conn.release();
  console.log("Conectado a DB " + database.database);
  return;
});

pool.query = promisify(pool.query);
module.exports = pool;
