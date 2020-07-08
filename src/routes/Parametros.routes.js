const { Router } = require("express");
const Auth = require("../middlewares/acceso");
const ParametrosCtrl = require("../controllers/Parametros.controller");

router = Router();
router
  .get("/tarifasiva", Auth.isAuth, ParametrosCtrl.consultartarifasiva)
  .get("/listasprecios", Auth.isAuth, ParametrosCtrl.consultarlistasprecios)
  .get("/numeracion", Auth.isAuth, ParametrosCtrl.consultarnumeracion)
  .get("/tiposdocumento", Auth.isAuth, ParametrosCtrl.consultartiposdocumento)
  .get("/regimenes", Auth.isAuth, ParametrosCtrl.consultarregimenes)
  .put("/tarifasiva/editar", Auth.isAuth, ParametrosCtrl.editartarifasiva)
  .put("/listasprecios/editar", Auth.isAuth, ParametrosCtrl.editarlistasprecios)
  .put("/numeracion/editar", Auth.isAuth, ParametrosCtrl.editarnumeracion)
  .post("/tarifasiva/crear", Auth.isAuth, ParametrosCtrl.creartarifasiva)
  .post("/listasprecios/crear", Auth.isAuth, ParametrosCtrl.crearlistasprecios)
  .post("/numeracion/crear", Auth.isAuth, ParametrosCtrl.crearnumeracion)
  .get("/*", ParametrosCtrl.error);

module.exports = router;
