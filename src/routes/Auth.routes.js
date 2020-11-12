const { Router } = require('express')
const UsuarioCtrl = require('../controllers/Auth.controller')
const Auth = require('../middlewares/acceso')

router = Router()
router
  .post('/ingresar', UsuarioCtrl.ingresar)
  .get('/validar', Auth.isAuth, UsuarioCtrl.validarToken)

module.exports = router
