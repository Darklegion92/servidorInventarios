const jwt = require('jsonwebtoken')
const moment = require('moment')
const keys = require('../config/keys')

function createToken (usuario) {
 
    const payload = {
      sub: usuario[0].idusuario+"J"+usuario[0].fechacreacion,
      iat: moment().unix(),
      exp: moment().add(1,'days').unix()
    }
    
    return jwt.sign(payload,keys.SECRET_TOKEN)
  }

  module.exports = {
    createToken
  }