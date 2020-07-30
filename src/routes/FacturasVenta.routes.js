const { Router } = require("express");
const Auth = require("../middlewares/acceso");
const FacturasCtrl = require("../controllers/FacturasVenta.controller");

router = Router();
router
  .post("/", Auth.isAuth, FacturasCtrl.crear)
  .post("/devolucion", Auth.isAuth, FacturasCtrl.devoluciones)
  .get("/ventasdia", FacturasCtrl.ventasDia)
  .get("/:numero", FacturasCtrl.consultarNumero)
  .get("/*", FacturasCtrl.error);

module.exports = router;
