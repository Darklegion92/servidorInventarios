const { Router } = require("express");
const Auth = require("../middlewares/acceso");
const AgrupacionesCtrl = require("../controllers/Agrupaciones.controller");

router = Router();
router
  .get("/grupos", Auth.isAuth, AgrupacionesCtrl.consultargrupos)
  .post("/grupos", Auth.isAuth, AgrupacionesCtrl.creargrupos)
  .put("/grupos", Auth.isAuth, AgrupacionesCtrl.editargrupos)
  .get("/subgrupos/:id", Auth.isAuth, AgrupacionesCtrl.consultarsubgrupos)
  .post("/subgrupos", Auth.isAuth, AgrupacionesCtrl.crearsubgrupos)
  .put("/subgrupos", Auth.isAuth, AgrupacionesCtrl.editarsubgrupos)
  .post("/marcas", Auth.isAuth, AgrupacionesCtrl.crearmarcas)
  .put("/marcas", Auth.isAuth, AgrupacionesCtrl.editarmarcas)
  .get("/marcas", Auth.isAuth, AgrupacionesCtrl.consultarmarcas)
  .get("/*", AgrupacionesCtrl.error);

module.exports = router;
