const { Router } = require("express");
const Auth = require("../middlewares/acceso");
const EntradasCtrl = require("../controllers/Entradas.controller");

router = Router();
router.post("/", Auth.isAuth, EntradasCtrl.crear).get("/*", EntradasCtrl.error);

module.exports = router;
