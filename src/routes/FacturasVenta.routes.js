const { Router } = require("express");
const Auth = require("../middlewares/acceso");
const FacturasCtrl = require("../controllers/FacturasVenta.controller");

router = Router();
router.post("/", Auth.isAuth, FacturasCtrl.crear).get("/*", FacturasCtrl.error);

module.exports = router;
