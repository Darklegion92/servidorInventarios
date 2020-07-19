const { Router } = require("express");
const Auth = require("../middlewares/acceso");
const ProveedoresCtrl = require("../controllers/Proveedores.controller");

router = Router();
router
  .get("/", Auth.isAuth, ProveedoresCtrl.consultar)
  .get("/:documento", Auth.isAuth, ProveedoresCtrl.consultarDocumento)
  .get("/filtros/:tipo", Auth.isAuth, ProveedoresCtrl.consultar)
  .get("/filtros/:tipo/:dato", Auth.isAuth, ProveedoresCtrl.consultarParametros)
  .put("/editar", Auth.isAuth, ProveedoresCtrl.editar)
  .post("/crear", Auth.isAuth, ProveedoresCtrl.crear)
  .get("/*", ProveedoresCtrl.error);

module.exports = router;
