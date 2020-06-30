const { Router } = require("express");
const UsuarioCtrl = require("../controllers/Usuario.controller");

router = Router();
router.post("/login", UsuarioCtrl.login)
      .get("/*", UsuarioCtrl.error);

module.exports = router;
