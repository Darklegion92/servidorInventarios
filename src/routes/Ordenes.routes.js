const { Router } = require("express");
const Auth = require("../middlewares/acceso");
const OrdenesCtrl = require("../controllers/Ordenes.controller");

router = Router();
router.post("/", Auth.isAuth, OrdenesCtrl.crear).get("/*", OrdenesCtrl.error);

module.exports = router;
