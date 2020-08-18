const express = require("express");
const morgan = require("morgan");
const bodyParser = require("body-parser");
const cors = require("cors");
const path = require("path");
const passport = require("passport");
const authRouter = require("./routes/Auth.routes");
const parametrosRouter = require("./routes/Parametros.routes");
const proveedoresRouter = require("./routes/Proveedores.routes");
const agrupacionesRouter = require("./routes/Agrupaciones.routes");
const articulosRouter = require("./routes/Articulos.routes");
const ordenesRouter = require("./routes/Ordenes.routes");
const facturasCompraRouter = require("./routes/FacturasCompra.routes");
const facturasVentaRouter = require("./routes/FacturasVenta.routes");
const clientesRouter = require("./routes/Clientes.routes");
const informesRouter = require("./routes/Informes.routes");
const { isAuth } = require("./middlewares/acceso");

//initializations
const app = express();
require("./lib/passport");
//settings
app.set("port", process.env.PORT || 3002);

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
app.use("/parametros", parametrosRouter);
app.use("/proveedores", proveedoresRouter);
app.use("/agrupaciones", agrupacionesRouter);
app.use("/articulos", articulosRouter);
app.use("/ordenes", ordenesRouter);
app.use("/facturascompra", facturasCompraRouter);
app.use("/facturasventa", facturasVentaRouter);
app.use("/clientes", clientesRouter);
app.use("/informes", informesRouter);
app.use("/", isAuth, (req, res) => {
  res.status(200).send({ mensaje: "tokenValido" });
});

//Public
app.use(express.static(path.join(__dirname, "public")));
//Starting the server
app.listen(app.get("port"), () => {
  console.log("Servidor Corriendo en el puerto " + app.get("port"));
});
