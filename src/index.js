const express = require("express");
const morgan = require("morgan");
const bodyParser = require("body-parser");
const cors = require("cors");
const path = require("path");
const passport = require("passport");
const authRouter = require("./routes/Auth.routes")

//initializations
const app = express();
require("./lib/passport");
//settings
app.set("port", process.env.PORT || 3001);

//middlewares
app.use(cors());
app.use(morgan("dev"));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(passport.initialize());
app.use(passport.session());

//Global Variables

//Routes
app.use("/", authRouter);

//Public
app.use(express.static(path.join(__dirname, "public")));
//Starting the server
app.listen(app.get("port"), () => {
  console.log("Servidor Corriendo en el puerto " + app.get("port"));
});
