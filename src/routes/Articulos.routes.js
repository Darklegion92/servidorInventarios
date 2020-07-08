const { Router } = require("express");
const Auth = require("../middlewares/acceso");
const ArticulosCtrl = require("../controllers/Articulos.controller");

router = Router();
router
  .get("/", Auth.isAuth, ArticulosCtrl.consultar)
  .get("/precios/:id", Auth.isAuth, ArticulosCtrl.consultarPrecios)
  .post("/", Auth.isAuth, ArticulosCtrl.crear)
  .get("/*", ArticulosCtrl.error);

module.exports = router;
