const { Router } = require("express");
const UsuarioCtrl = require("../controllers/Auth.controller");

router = Router();
router
  .post("/ingresar", UsuarioCtrl.ingresar)
  .get("/*", UsuarioCtrl.error);

module.exports = router;
