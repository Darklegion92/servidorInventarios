const { Router } = require("express");
const UsuarioCtrl = require("../controllers/Auth.controller");
const Auth = require("../middlewares/acceso");

router = Router();
router
  .post("/ingresar", UsuarioCtrl.ingresar)
  .post("/registrar", Auth.isAuth, UsuarioCtrl.crear)
  .get("/lista", Auth.isAuth, UsuarioCtrl.consultar)
  .get("/validar", Auth.isAuth, UsuarioCtrl.validarToken);

module.exports = router;
