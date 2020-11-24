const { Router } = require("express");
const { isAuth } = require("../middlewares/acceso");
const FacturasCtrl = require("../controllers/FacturasVenta.controller");

router = Router();
router
  .post("/", isAuth, FacturasCtrl.crear)
  .post("/devolucion", isAuth, FacturasCtrl.devoluciones)
  .get("/ventasdia", FacturasCtrl.ventasDia)
  .get("/numero", isAuth, FacturasCtrl.consultarNumero)
  .get("/*", FacturasCtrl.error);

module.exports = router;
