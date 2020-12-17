const { Router } = require("express");
const Auth = require("../middlewares/acceso");
const ParametrosCtrl = require("../controllers/Parametros.controller");

router = Router();
router
  .get("/tarifasiva", Auth.isAuth, ParametrosCtrl.consultartarifasiva)
  .get("/sucursales", ParametrosCtrl.consultarucursales)
  .get("/bodegas", Auth.isAuth, ParametrosCtrl.consultarbodegas)
  .get("/ordenes/numero", Auth.isAuth, ParametrosCtrl.consultarnumeroorden)
  .get(
    '/facturasventa/numero/:idsucursal',
    Auth.isAuth,
    ParametrosCtrl.consultarnumerofacturaventa
  )
  .get(
    "/facturascompra/numero",
    Auth.isAuth,
    ParametrosCtrl.consultarnumerofacturacompra
  )
  .get("/informes/facturacion", Auth.isAuth, ParametrosCtrl.informesFacturacion)
  .get("/listasprecios", Auth.isAuth, ParametrosCtrl.consultarlistasprecios)
  .get("/numeracion", Auth.isAuth, ParametrosCtrl.consultarnumeracion)
  .get("/tiposdocumento", Auth.isAuth, ParametrosCtrl.consultartiposdocumento)
  .get("/regimenes", Auth.isAuth, ParametrosCtrl.consultarregimenes)
  .get("/roles", Auth.isAuth, ParametrosCtrl.consultarroles)
  .put("/tarifasiva/editar", Auth.isAuth, ParametrosCtrl.editartarifasiva)
  .put("/listasprecios/editar", Auth.isAuth, ParametrosCtrl.editarlistasprecios)
  .put("/numeracion/editar", Auth.isAuth, ParametrosCtrl.editarnumeracion)
  .put("/bodegas", Auth.isAuth, ParametrosCtrl.editarbodega)
  .put("/sucursales", Auth.isAuth, ParametrosCtrl.editarsucursal)
  .post("/tarifasiva/crear", Auth.isAuth, ParametrosCtrl.creartarifasiva)
  .post("/listasprecios/crear", Auth.isAuth, ParametrosCtrl.crearlistasprecios)
  .post("/numeracion/crear", Auth.isAuth, ParametrosCtrl.crearnumeracion)
  .post("/bodegas", Auth.isAuth, ParametrosCtrl.crearbodega)
  .post("/sucursales", Auth.isAuth, ParametrosCtrl.crearsucursal)
  .get("/*", ParametrosCtrl.error);

module.exports = router;
