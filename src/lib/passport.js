const passport = require("passport");
const LocalStrategy = require("passport-local").Strategy;

passport.use(
  "local.signup",
  new LocalStrategy(
    {
      usuarioCampo: "usuario",
      passwordCampo: "password",
      passReqToCallback: true,
    },
    async (req, usuario, password, done) => {
      console.log(req.body);
    }
  )
);
