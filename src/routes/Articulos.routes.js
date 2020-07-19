const { Router } = require("express");
const Auth = require("../middlewares/acceso");
const ArticulosCtrl = require("../controllers/Articulos.controller");

router = Router();
router
  .get("/", Auth.isAuth, ArticulosCtrl.consultar)
  .get("/precios/:id", Auth.isAuth, ArticulosCtrl.consultarPrecios)
  .get("/filtro/:tipo", Auth.isAuth, ArticulosCtrl.consultar)
  .get("/:tipo/:dato", Auth.isAuth, ArticulosCtrl.consultarOrden)
  .get("/filtro/:tipo/:dato", Auth.isAuth, ArticulosCtrl.consultarParametros)
  .get("/:tipo/:dato/:idlistaprecios", Auth.isAuth, ArticulosCtrl.consultarVentas)
  .put("/", Auth.isAuth, ArticulosCtrl.editar)
  .post("/", Auth.isAuth, ArticulosCtrl.crear)
  .get("/*", ArticulosCtrl.error);

module.exports = router;
