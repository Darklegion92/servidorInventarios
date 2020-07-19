const { Router } = require("express");
const Auth = require("../middlewares/acceso");
const ClientesCtrl = require("../controllers/Clientes.controller");

router = Router();
router
  .get("/", Auth.isAuth, ClientesCtrl.consultar)
  .get("/:documento", Auth.isAuth, ClientesCtrl.consultarDocumento)
  .get("/filtros/:tipo", Auth.isAuth, ClientesCtrl.consultar)
  .get("/filtros/:tipo/:dato", Auth.isAuth, ClientesCtrl.consultarParametros)
  .put("/editar", Auth.isAuth, ClientesCtrl.editar)
  .post("/crear", Auth.isAuth, ClientesCtrl.crear)
  .get("/*", ClientesCtrl.error);

module.exports = router;
