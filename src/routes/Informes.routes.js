const { Router } = require("express");
const Auth = require("../middlewares/acceso");
const InformesCtrl = require("../controllers/Informes.controller");

router = Router();
router
  .get("/:tipo", Auth.isAuth, InformesCtrl.articulos)
  .get("/*", InformesCtrl.error);

module.exports = router;
