-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 24-11-2020 a las 22:44:01
-- Versión del servidor: 10.4.14-MariaDB
-- Versión de PHP: 7.4.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `soltec`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `inicializar_database` (IN `valor` VARCHAR(1))  BEGIN
IF VALOR='T' THEN
	DELETE FROM inventario;
    ALTER TABLE inventario AUTO_INCREMENT = 1;
    DELETE FROM movimiento_articulos;
    ALTER TABLE movimiento_articulos AUTO_INCREMENT = 1;
    DELETE FROM factura_compra_detalles;
    ALTER TABLE factura_compra_detalles AUTO_INCREMENT = 1;
    DELETE FROM factura_venta_detalles;
    ALTER TABLE factura_venta_detalles AUTO_INCREMENT = 1;
    DELETE FROM orden_compra_detalles;
    ALTER TABLE orden_compra_detalles AUTO_INCREMENT = 1;
    DELETE FROM facturas_compra;
    ALTER TABLE facturas_compra AUTO_INCREMENT = 1;
    DELETE FROM facturas_venta;
    ALTER TABLE facturas_venta AUTO_INCREMENT = 1;
    DELETE FROM ordenes_compra;
    ALTER TABLE ordenes_compra AUTO_INCREMENT = 1;
    DELETE FROM precios;
    ALTER TABLE precios AUTO_INCREMENT = 1;
     DELETE FROM articulos;
    ALTER TABLE articulos AUTO_INCREMENT = 1;
    DELETE FROM subgrupos;
    ALTER TABLE subgrupos AUTO_INCREMENT = 1;
    DELETE FROM grupos;
    ALTER TABLE grupos AUTO_INCREMENT = 1;
    DELETE FROM marcas;
    ALTER TABLE marcas AUTO_INCREMENT = 1;
    DELETE FROM clientes;
    ALTER TABLE clientes AUTO_INCREMENT = 1;
    DELETE FROM listasprecios;
    ALTER TABLE listasprecios AUTO_INCREMENT = 1;
    DELETE FROM numeracion;
    ALTER TABLE numeracion AUTO_INCREMENT = 1;
    DELETE FROM proveedores;
    ALTER TABLE proveedores AUTO_INCREMENT = 1;
    DELETE FROM regimenes;
    ALTER TABLE regimenes AUTO_INCREMENT = 1;
    DELETE FROM roles_permisos WHERE idrol!=1;
    DELETE FROM tarifasiva;
    ALTER TABLE tarifasiva AUTO_INCREMENT = 1;
     DELETE FROM tipos_documento;
    ALTER TABLE tipos_documento AUTO_INCREMENT = 1;
	DELETE FROM usuarios WHERE idusuario!=1;
    ALTER TABLE usuarios AUTO_INCREMENT = 2;	
END IF;
IF VALOR='P' THEN
DELETE FROM inventario;
    ALTER TABLE inventario AUTO_INCREMENT = 1;
    DELETE FROM movimiento_articulos;
    ALTER TABLE movimiento_articulos AUTO_INCREMENT = 1;
    DELETE FROM factura_compra_detalles;
    ALTER TABLE factura_compra_detalles AUTO_INCREMENT = 1;
    DELETE FROM factura_venta_detalles;
    ALTER TABLE factura_venta_detalles AUTO_INCREMENT = 1;
    DELETE FROM orden_compra_detalles;
    ALTER TABLE orden_compra_detalles AUTO_INCREMENT = 1;
    DELETE FROM facturas_compra;
    ALTER TABLE facturas_compra AUTO_INCREMENT = 1;
    DELETE FROM facturas_venta;
    ALTER TABLE facturas_venta AUTO_INCREMENT = 1;
    DELETE FROM ordenes_compra;
    ALTER TABLE ordenes_compra AUTO_INCREMENT = 1;
     DELETE FROM devoluciones_ventas;
    ALTER TABLE devoluciones_ventas AUTO_INCREMENT = 1;
    DELETE FROM sucursales;
    ALTER TABLE sucursales AUTO_INCREMENT = 1;
    DELETE FROM bodegas;
    ALTER TABLE bodegas AUTO_INCREMENT = 1;
    
END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `articulos`
--

CREATE TABLE `articulos` (
  `idarticulo` int(11) NOT NULL,
  `descripcion` varchar(150) NOT NULL,
  `codigo` varchar(20) NOT NULL,
  `idtarifaiva` int(11) NOT NULL,
  `idgrupo` int(11) NOT NULL,
  `idsubgrupo` int(11) NOT NULL,
  `idmarca` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `fechacreacion` datetime NOT NULL,
  `estado` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bodegas`
--

CREATE TABLE `bodegas` (
  `id` int(11) NOT NULL,
  `nombre` varchar(20) NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1,
  `idsucursal` int(11) NOT NULL,
  `principal` tinyint(1) NOT NULL DEFAULT 0,
  `idusuario` int(11) DEFAULT NULL,
  `fechacreacion` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `idcliente` int(11) NOT NULL,
  `nombres` varchar(60) NOT NULL,
  `apellidos` varchar(60) NOT NULL,
  `documento` varchar(10) NOT NULL,
  `direccion` varchar(100) DEFAULT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `idtipo_documento` int(11) NOT NULL,
  `idlistaprecios` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `fechacreacion` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `devoluciones_ventas`
--

CREATE TABLE `devoluciones_ventas` (
  `iddevolucion_ventas` int(11) NOT NULL,
  `idfactura_venta_detalle` int(11) NOT NULL,
  `estado` tinyint(4) NOT NULL DEFAULT 1,
  `idusuario` int(11) NOT NULL,
  `fechacreacion` datetime NOT NULL,
  `idbodega` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Disparadores `devoluciones_ventas`
--
DELIMITER $$
CREATE TRIGGER `ajuste_inventarios` AFTER INSERT ON `devoluciones_ventas` FOR EACH ROW BEGIN
	SET @IDFACTURA = (SELECT idfactura_venta FROM factura_venta_detalles WHERE idfactura_venta_detalle = NEW.idfactura_venta_detalle);
    SET @CODIGO = (SELECT codigoarticulo FROM factura_venta_detalles WHERE idfactura_venta_detalle = NEW.idfactura_venta_detalle);
    SET @IDARTICULO = (SELECT idarticulo FROM articulos WHERE codigo=@CODIGO);
    SET @ID =  (SELECT idinventario FROM inventario WHERE idarticulo = @IDARTICULO AND idbodega = NEW.idbodega);
	SET @CANTIDAD = (SELECT cantidadarticulo FROM factura_venta_detalles WHERE idfactura_venta_detalle = NEW.idfactura_venta_detalle);
    
    UPDATE facturas_venta SET iddevolucion_ventas = NEW.iddevolucion_ventas WHERE idfactura_venta = @IDFACTURA;
	INSERT INTO movimiento_articulos SET idarticulo = @IDARTICULO, tipomovimiento='E',cantidad= @CANTIDAD, fechacreacion=NOW(), idbodega=NEW.idbodega;
    UPDATE inventario SET cantidad = cantidad +@CANTIDAD WHERE idinventario = @ID;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `entradas`
--

CREATE TABLE `entradas` (
  `id` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `fechacreacion` datetime NOT NULL,
  `estado` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `entradas_detalle`
--

CREATE TABLE `entradas_detalle` (
  `id` int(11) NOT NULL,
  `identrada` int(11) NOT NULL,
  `codigoarticulo` varchar(20) NOT NULL,
  `descripcionarticulo` varchar(150) NOT NULL,
  `cantidadarticulo` double NOT NULL,
  `valorarticulo` double NOT NULL,
  `ivaarticulo` double NOT NULL,
  `idtarifaiva` int(11) NOT NULL,
  `idbodega` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Disparadores `entradas_detalle`
--
DELIMITER $$
CREATE TRIGGER `inventario_entrada` BEFORE INSERT ON `entradas_detalle` FOR EACH ROW BEGIN
SET
    @IDARTICULO = (
        SELECT
            idarticulo
        FROM
            articulos
        WHERE
            codigo = NEW.codigoarticulo
    );

SET
    @ID = (
        SELECT
            idinventario
        FROM
            inventario
        WHERE
            idarticulo = @IDARTICULO
            AND idbodega = NEW.idbodega
    );

INSERT INTO
    movimiento_articulos
SET
    idarticulo = @IDARTICULO,
    tipomovimiento = 'E',
    cantidad = NEW.cantidadarticulo,
    fechacreacion = NOW(),
    idbodega = NEW.idbodega;

IF @ID > 0 THEN
UPDATE
    inventario
SET
    cantidad = cantidad + NEW.cantidadarticulo,
    costopromedio = (NEW.valorarticulo + costopromedio) / 2
WHERE
    idinventario = @ID;

ELSE
INSERT INTO
    inventario(
        idarticulo,
        cantidad,
        costopromedio,
        ultimocosto,
        idbodega
    )
VALUES
    (
        @IDARTICULO,
        NEW.cantidadarticulo,
        NEW.valorarticulo,
        New.valorarticulo,
        NEW.idbodega
    );

END IF;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `facturas_compra`
--

CREATE TABLE `facturas_compra` (
  `idfactura_compra` int(11) NOT NULL,
  `idproveedor` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `fechacreacion` datetime NOT NULL,
  `estado` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `facturas_venta`
--

CREATE TABLE `facturas_venta` (
  `idfactura_venta` int(11) NOT NULL,
  `idcliente` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `fechacreacion` datetime NOT NULL,
  `estado` tinyint(4) NOT NULL DEFAULT 1,
  `prefijo` varchar(5) NOT NULL,
  `numero` int(11) NOT NULL,
  `iddevolucion_ventas` int(11) DEFAULT NULL,
  `recibido` double NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Disparadores `facturas_venta`
--
DELIMITER $$
CREATE TRIGGER `facturas_venta_AFTER_INSERT` AFTER INSERT ON `facturas_venta` FOR EACH ROW BEGIN
	UPDATE numeracion SET numero = numero+1 WHERE prefijo = NEW.prefijo;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `factura_compra_detalles`
--

CREATE TABLE `factura_compra_detalles` (
  `idfactura_compra_detalle` int(11) NOT NULL,
  `codigoarticulo` varchar(20) NOT NULL,
  `descripcionarticulo` varchar(150) NOT NULL,
  `cantidadarticulo` double NOT NULL,
  `valorarticulo` double NOT NULL,
  `ivaarticulo` double NOT NULL DEFAULT 0,
  `idtarifaiva` int(11) NOT NULL,
  `idfactura_compra` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Disparadores `factura_compra_detalles`
--
DELIMITER $$
CREATE TRIGGER `mov_inventario_compra` AFTER INSERT ON `factura_compra_detalles` FOR EACH ROW BEGIN
	SET @IDARTICULO = (SELECT idarticulo FROM articulos WHERE codigo=NEW.codigoarticulo);
	SET @ID =  (SELECT idinventario FROM inventario WHERE idarticulo = @IDARTICULO);
    INSERT INTO movimiento_articulos SET idarticulo = @IDARTICULO, tipomovimiento='E',cantidad= NEW.cantidadarticulo,fechacreacion=NOW();
    IF @ID>0 THEN
    UPDATE inventario SET cantidad = cantidad + NEW.cantidadarticulo, costopromedio = (costopromedio+NEW.valorarticulo)/2, ultimocosto=NEW.valorarticulo WHERE idinventario = @ID;
    ELSE
    INSERT INTO inventario(idarticulo,cantidad, costopromedio,ultimocosto) VALUES(@IDARTICULO,NEW.cantidadarticulo,NEW.valorarticulo,NEW.valorarticulo);
    END IF;
    
  END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `factura_venta_detalles`
--

CREATE TABLE `factura_venta_detalles` (
  `idfactura_venta_detalle` int(11) NOT NULL,
  `codigoarticulo` varchar(20) NOT NULL,
  `descripcionarticulo` varchar(150) NOT NULL,
  `cantidadarticulo` double NOT NULL,
  `valorarticulo` double NOT NULL,
  `ivaarticulo` double NOT NULL DEFAULT 0,
  `idtarifaiva` int(11) NOT NULL,
  `idfactura_venta` int(11) NOT NULL,
  `idbodega` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Disparadores `factura_venta_detalles`
--
DELIMITER $$
CREATE TRIGGER `mov_inventario_ventas` AFTER INSERT ON `factura_venta_detalles` FOR EACH ROW BEGIN
	SET @IDARTICULO = (SELECT idarticulo FROM articulos WHERE codigo=NEW.codigoarticulo);
	SET @ID =  (SELECT idinventario FROM inventario WHERE idarticulo = @IDARTICULO AND idbodega=NEW.idbodega);
    INSERT INTO movimiento_articulos SET idarticulo = @IDARTICULO, tipomovimiento='S',cantidad= NEW.cantidadarticulo, fechacreacion=NOW(),idbodega=NEW.idbodega;
    IF @ID>0 THEN
		UPDATE inventario SET cantidad = cantidad -NEW.cantidadarticulo WHERE idinventario = @ID;
    ELSE
		INSERT INTO inventario(idarticulo,cantidad, costopromedio,ultimocosto,idbodega) VALUES(@IDARTICULO,-NEW.cantidadarticulo,0,0,NEW.idbodega);
    END IF;
    
  END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `grupos`
--

CREATE TABLE `grupos` (
  `idgrupo` int(11) NOT NULL,
  `nombre` varchar(45) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `fechacreacion` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inventario`
--

CREATE TABLE `inventario` (
  `idinventario` int(11) NOT NULL,
  `idarticulo` int(11) NOT NULL,
  `cantidad` double NOT NULL,
  `costopromedio` double NOT NULL,
  `ultimocosto` double NOT NULL,
  `idbodega` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `listasprecios`
--

CREATE TABLE `listasprecios` (
  `idlistaprecios` int(11) NOT NULL,
  `nombre` varchar(45) NOT NULL,
  `fechacreacion` datetime NOT NULL,
  `idusuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `marcas`
--

CREATE TABLE `marcas` (
  `idmarca` int(11) NOT NULL,
  `nombre` varchar(45) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `fechacreacion` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `movimiento_articulos`
--

CREATE TABLE `movimiento_articulos` (
  `idmovimiento_articulo` int(11) NOT NULL,
  `idarticulo` int(11) NOT NULL,
  `tipomovimiento` varchar(1) NOT NULL,
  `cantidad` double NOT NULL,
  `fechacreacion` datetime NOT NULL,
  `idbodega` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `numeracion`
--

CREATE TABLE `numeracion` (
  `idnumeracion` int(11) NOT NULL,
  `prefijo` varchar(5) NOT NULL,
  `numero` int(11) NOT NULL,
  `autorizacion` varchar(50) DEFAULT NULL,
  `fechaautorizacion` date DEFAULT NULL,
  `fechavencimiento` date DEFAULT NULL,
  `idusuario` int(11) DEFAULT NULL,
  `extension` tinyint(4) NOT NULL DEFAULT 0,
  `fechacreacion` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ordenes_compra`
--

CREATE TABLE `ordenes_compra` (
  `idorden_compra` int(11) NOT NULL,
  `idproveedor` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `fechacreacion` datetime NOT NULL,
  `estado` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `orden_compra_detalles`
--

CREATE TABLE `orden_compra_detalles` (
  `idorden_compra_detalle` int(11) NOT NULL,
  `codigoarticulo` varchar(20) NOT NULL,
  `descripcionarticulo` varchar(150) NOT NULL,
  `cantidadarticulo` double NOT NULL,
  `valorarticulo` double NOT NULL,
  `ivaarticulo` double NOT NULL DEFAULT 0,
  `idtarifaiva` int(11) NOT NULL,
  `idorden_compra` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos`
--

CREATE TABLE `permisos` (
  `idpermiso` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `detalle` varchar(150) DEFAULT NULL,
  `modulo` varchar(20) NOT NULL,
  `fechacreacion` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `permisos`
--

INSERT INTO `permisos` (`idpermiso`, `nombre`, `detalle`, `modulo`, `fechacreacion`) VALUES
(1, 'ACCESO MODULO', 'Acceso al modulo facturación', 'FACTURACION', '2020-06-29'),
(2, 'FACTURAS REGISTRO', 'Acceso para registrar facturas de venta', 'FACTURACION', '2020-06-29'),
(3, 'GESTION PARAMETROS', 'Acceso para gestionar parámetros de configuración de facturación', 'FACTURACION', '2020-06-29'),
(4, 'INFORMES', 'Acceso para ingresar a los informes de facturación', 'FACTURACION', '2020-06-29'),
(5, 'DEVOLUCIONES REGISTRO', 'Acceso para registrar devoluciones en facturas de venta', 'FACTURACION', '2020-06-29');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `precios`
--

CREATE TABLE `precios` (
  `idprecio` int(11) NOT NULL,
  `idlistaprecios` int(11) NOT NULL,
  `idarticulo` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `fechacreacion` datetime NOT NULL,
  `valor` double NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

CREATE TABLE `proveedores` (
  `idproveedor` int(11) NOT NULL,
  `idtipo_documento` int(11) NOT NULL,
  `documento` varchar(15) NOT NULL,
  `razonsocial` varchar(100) NOT NULL,
  `nombres` varchar(30) NOT NULL,
  `apellidos` varchar(30) NOT NULL,
  `direccion` varchar(100) DEFAULT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `correo` varchar(45) DEFAULT NULL,
  `idregimen` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `fechacreacion` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `regimenes`
--

CREATE TABLE `regimenes` (
  `idregimen` int(11) NOT NULL,
  `nombre` varchar(45) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `fechacreacion` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `regimenes`
--

INSERT INTO `regimenes` (`idregimen`, `nombre`, `idusuario`, `fechacreacion`) VALUES
(1, 'SIMPLIFICADO', 1, '2020-07-20 11:57:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `idrol` int(11) NOT NULL,
  `nombre` varchar(45) NOT NULL,
  `fechacreacion` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='se encarga de guardar los roles de los usuarios';

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`idrol`, `nombre`, `fechacreacion`) VALUES
(1, 'ADMINISTRADOR', '2020-06-29');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles_permisos`
--

CREATE TABLE `roles_permisos` (
  `idroles_permisos` int(11) NOT NULL,
  `idrol` int(11) NOT NULL,
  `idpermiso` int(11) NOT NULL,
  `fechacreacion` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `subgrupos`
--

CREATE TABLE `subgrupos` (
  `idsubgrupo` int(11) NOT NULL,
  `nombre` varchar(45) NOT NULL,
  `idgrupo` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `fechacreacion` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sucursales`
--

CREATE TABLE `sucursales` (
  `id` int(11) NOT NULL,
  `nombre` varchar(20) NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1,
  `idusuario` int(11) NOT NULL,
  `fechacreacion` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tarifasiva`
--

CREATE TABLE `tarifasiva` (
  `idtarifaiva` int(11) NOT NULL,
  `nombre` varchar(20) NOT NULL,
  `tarifa` int(11) NOT NULL,
  `fechacreacion` datetime NOT NULL,
  `idusuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos_documento`
--

CREATE TABLE `tipos_documento` (
  `idtipo_documento` int(11) NOT NULL,
  `prefijo` varchar(4) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `fechacreacion` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tipos_documento`
--

INSERT INTO `tipos_documento` (`idtipo_documento`, `prefijo`, `nombre`, `idusuario`, `fechacreacion`) VALUES
(1, 'CC', 'CEDULA DE CIUDADANIA', 1, '2020-07-19 19:17:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos_informe`
--

CREATE TABLE `tipos_informe` (
  `idtipo_informe` int(11) NOT NULL,
  `nombre` varchar(45) NOT NULL,
  `modulo` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tipos_informe`
--

INSERT INTO `tipos_informe` (`idtipo_informe`, `nombre`, `modulo`) VALUES
(1, 'VENTAS X ARTICULO', 'FACTURACION');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `idusuario` int(11) NOT NULL,
  `usuario` varchar(8) NOT NULL,
  `password` varchar(12) NOT NULL,
  `idRol` int(11) NOT NULL,
  `asignacion` varchar(50) NOT NULL,
  `fechacreacion` datetime NOT NULL,
  `idsucursal` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`idusuario`, `usuario`, `password`, `idRol`, `asignacion`, `fechacreacion`, `idsucursal`) VALUES
(1, 'ADMIN', '1234', 1, 'ADMINISTRADOR DEL SISTEMA', '2020-06-29 00:00:00', 1),
(11, 'PRUEBA', '1234', 1, 'PRUEBAS PARA HOY NO', '2020-11-12 14:14:58', 1),
(12, 'PRUEBA 2', '1234', 1, 'NO HAY NADA', '2020-11-12 14:32:34', 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `articulos`
--
ALTER TABLE `articulos`
  ADD PRIMARY KEY (`idarticulo`),
  ADD UNIQUE KEY `idarticulo_UNIQUE` (`idarticulo`),
  ADD UNIQUE KEY `codigo_UNIQUE` (`codigo`),
  ADD KEY `fgk_tarifasiva_articulos_idx` (`idtarifaiva`),
  ADD KEY `fgk_grupos_articulos_idx` (`idgrupo`),
  ADD KEY `fgk_subgrupos_articulos_idx` (`idsubgrupo`),
  ADD KEY `fgk_marcas_articulos_idx` (`idmarca`),
  ADD KEY `fgk_usuarios_articulos_idx` (`idusuario`);

--
-- Indices de la tabla `bodegas`
--
ALTER TABLE `bodegas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`),
  ADD KEY `fgk_sucursales_bodegas` (`idsucursal`),
  ADD KEY `fgk_usuarios_bodegas` (`idusuario`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`idcliente`),
  ADD UNIQUE KEY `idcliente_UNIQUE` (`idcliente`),
  ADD UNIQUE KEY `documento_UNIQUE` (`documento`),
  ADD KEY `fgk_tipos_documento_clientes_idx` (`idtipo_documento`),
  ADD KEY `fgk_usuarios_clientes_idx` (`idusuario`),
  ADD KEY `fgk_listas_precios_clientes_idx` (`idlistaprecios`);

--
-- Indices de la tabla `devoluciones_ventas`
--
ALTER TABLE `devoluciones_ventas`
  ADD PRIMARY KEY (`iddevolucion_ventas`),
  ADD UNIQUE KEY `iddevolucion_ventas_UNIQUE` (`iddevolucion_ventas`),
  ADD KEY `fgk_factura_venta_detalles_devolucione_ventas_idx` (`idfactura_venta_detalle`),
  ADD KEY `fgk_bodegas_devoluciones_ventas` (`idbodega`);

--
-- Indices de la tabla `entradas`
--
ALTER TABLE `entradas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fgk_usuarios_entradas` (`idusuario`);

--
-- Indices de la tabla `entradas_detalle`
--
ALTER TABLE `entradas_detalle`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fgk_bodegas_entradas_detalle` (`idbodega`),
  ADD KEY `fgk_entradas_entradas_detalle` (`identrada`),
  ADD KEY `fgk_tarifaiva_entradas_detalle` (`idtarifaiva`);

--
-- Indices de la tabla `facturas_compra`
--
ALTER TABLE `facturas_compra`
  ADD PRIMARY KEY (`idfactura_compra`),
  ADD UNIQUE KEY `idfactura_compra_UNIQUE` (`idfactura_compra`),
  ADD KEY `fgk_proveedores_facturas_compra_idx` (`idproveedor`),
  ADD KEY `fgk_usuarios_facturas_compra_idx` (`idusuario`);

--
-- Indices de la tabla `facturas_venta`
--
ALTER TABLE `facturas_venta`
  ADD PRIMARY KEY (`idfactura_venta`),
  ADD UNIQUE KEY `idfactura_venta_UNIQUE` (`idfactura_venta`),
  ADD KEY `fgk_clientes_facturas_venta_idx` (`idcliente`),
  ADD KEY `fgk_usuarios_facturas_venta_idx` (`idusuario`),
  ADD KEY `fgk_numeracion_facturas_venta_idx` (`prefijo`);

--
-- Indices de la tabla `factura_compra_detalles`
--
ALTER TABLE `factura_compra_detalles`
  ADD PRIMARY KEY (`idfactura_compra_detalle`),
  ADD UNIQUE KEY `idfactura_compra_detalle_UNIQUE` (`idfactura_compra_detalle`),
  ADD KEY `fgk_articulos_factura_compra_detalles_idx` (`codigoarticulo`),
  ADD KEY `fgk_tarifasiva_factura_compra_detalles_idx` (`idtarifaiva`),
  ADD KEY `fgk_facturas_compra_factura_compra_detalles_idx` (`idfactura_compra`);

--
-- Indices de la tabla `factura_venta_detalles`
--
ALTER TABLE `factura_venta_detalles`
  ADD PRIMARY KEY (`idfactura_venta_detalle`),
  ADD UNIQUE KEY `idfactura_venta_detalle_UNIQUE` (`idfactura_venta_detalle`),
  ADD KEY `fgk_articulos_factura_venta_detalles_idx` (`codigoarticulo`),
  ADD KEY `fgk_tarifasiva_factura_venta_detalles_idx` (`idtarifaiva`),
  ADD KEY `fgk_facturas_venta_factura_venta_detalles_idx` (`idfactura_venta`),
  ADD KEY `fgk_bodegas_factura_venta` (`idbodega`);

--
-- Indices de la tabla `grupos`
--
ALTER TABLE `grupos`
  ADD PRIMARY KEY (`idgrupo`),
  ADD UNIQUE KEY `idgrupo_UNIQUE` (`idgrupo`),
  ADD UNIQUE KEY `nombre_UNIQUE` (`nombre`),
  ADD KEY `fgk_usuarios_grupos_idx` (`idusuario`);

--
-- Indices de la tabla `inventario`
--
ALTER TABLE `inventario`
  ADD PRIMARY KEY (`idinventario`),
  ADD UNIQUE KEY `idinventario_UNIQUE` (`idinventario`),
  ADD KEY `fgk_articulos_inventario_idx` (`idarticulo`),
  ADD KEY `fgk_bodegas_inventario` (`idbodega`);

--
-- Indices de la tabla `listasprecios`
--
ALTER TABLE `listasprecios`
  ADD PRIMARY KEY (`idlistaprecios`),
  ADD UNIQUE KEY `idlistaprecios_UNIQUE` (`idlistaprecios`),
  ADD UNIQUE KEY `nombre_UNIQUE` (`nombre`),
  ADD KEY `fgk_usuarios_listasprecios_idx` (`idusuario`);

--
-- Indices de la tabla `marcas`
--
ALTER TABLE `marcas`
  ADD PRIMARY KEY (`idmarca`),
  ADD UNIQUE KEY `idmarca_UNIQUE` (`idmarca`);

--
-- Indices de la tabla `movimiento_articulos`
--
ALTER TABLE `movimiento_articulos`
  ADD PRIMARY KEY (`idmovimiento_articulo`),
  ADD UNIQUE KEY `idmovimiento_articulo_UNIQUE` (`idmovimiento_articulo`),
  ADD KEY `fgk_articulos_movimiento_articulos_idx` (`idarticulo`),
  ADD KEY `fgk_bodegas_movimiento_articulos` (`idbodega`);

--
-- Indices de la tabla `numeracion`
--
ALTER TABLE `numeracion`
  ADD PRIMARY KEY (`idnumeracion`),
  ADD UNIQUE KEY `idnumeracion_UNIQUE` (`idnumeracion`),
  ADD UNIQUE KEY `prefijo_UNIQUE` (`prefijo`),
  ADD KEY `fgk_usuarios_numeracion_idx` (`idusuario`);

--
-- Indices de la tabla `ordenes_compra`
--
ALTER TABLE `ordenes_compra`
  ADD PRIMARY KEY (`idorden_compra`),
  ADD UNIQUE KEY `idorden_compra_UNIQUE` (`idorden_compra`),
  ADD KEY `fgk_proveedores_ordenes_compra_idx` (`idproveedor`),
  ADD KEY `fgk_usuarios_ordenes_compra_idx` (`idusuario`);

--
-- Indices de la tabla `orden_compra_detalles`
--
ALTER TABLE `orden_compra_detalles`
  ADD PRIMARY KEY (`idorden_compra_detalle`),
  ADD UNIQUE KEY `idorden_compra_detalle_UNIQUE` (`idorden_compra_detalle`),
  ADD KEY `fgk_articulos_orden_compra_detalles_idx` (`codigoarticulo`),
  ADD KEY `fgk_tarifasiva_orden_compra_detalles_idx` (`idtarifaiva`),
  ADD KEY `fgk_ordenes_compra_orden_compra_detalles_idx` (`idorden_compra`);

--
-- Indices de la tabla `permisos`
--
ALTER TABLE `permisos`
  ADD PRIMARY KEY (`idpermiso`),
  ADD UNIQUE KEY `idpermiso_UNIQUE` (`idpermiso`);

--
-- Indices de la tabla `precios`
--
ALTER TABLE `precios`
  ADD PRIMARY KEY (`idprecio`),
  ADD UNIQUE KEY `idprecio_UNIQUE` (`idprecio`),
  ADD KEY `fgk_listasprecios_idx` (`idlistaprecios`),
  ADD KEY `fgk_articulos_precios_idx` (`idarticulo`),
  ADD KEY `fgk_usuarios_precios_idx` (`idusuario`);

--
-- Indices de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  ADD PRIMARY KEY (`idproveedor`),
  ADD UNIQUE KEY `idproveedor_UNIQUE` (`idproveedor`),
  ADD UNIQUE KEY `documento_UNIQUE` (`documento`),
  ADD KEY `fgk_tipo_documento_proveedores_idx` (`idtipo_documento`),
  ADD KEY `fgk_regimenes_proveedor_idx` (`idregimen`),
  ADD KEY `fgk_usuario_proveedores_idx` (`idusuario`);

--
-- Indices de la tabla `regimenes`
--
ALTER TABLE `regimenes`
  ADD PRIMARY KEY (`idregimen`),
  ADD UNIQUE KEY `idregimen_UNIQUE` (`idregimen`),
  ADD UNIQUE KEY `nombre_UNIQUE` (`nombre`),
  ADD KEY `fgk_usuario_regimenes_idx` (`idusuario`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`idrol`),
  ADD UNIQUE KEY `idrol_UNIQUE` (`idrol`),
  ADD UNIQUE KEY `nombre_UNIQUE` (`nombre`);

--
-- Indices de la tabla `roles_permisos`
--
ALTER TABLE `roles_permisos`
  ADD PRIMARY KEY (`idroles_permisos`),
  ADD UNIQUE KEY `idroles_permisos_UNIQUE` (`idroles_permisos`),
  ADD KEY `fgk_roles_roles_permisos_idx` (`idrol`),
  ADD KEY `fgk_permisos_roles_permisos_idx` (`idpermiso`);

--
-- Indices de la tabla `subgrupos`
--
ALTER TABLE `subgrupos`
  ADD PRIMARY KEY (`idsubgrupo`),
  ADD UNIQUE KEY `idsubgrupo_UNIQUE` (`idsubgrupo`),
  ADD KEY `fgk_usuarios_subgrupos_idx` (`idusuario`),
  ADD KEY `fgk_grupos_subgrupos_idx` (`idgrupo`);

--
-- Indices de la tabla `sucursales`
--
ALTER TABLE `sucursales`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`),
  ADD KEY `fgk_usuarios_sucursales` (`idusuario`);

--
-- Indices de la tabla `tarifasiva`
--
ALTER TABLE `tarifasiva`
  ADD PRIMARY KEY (`idtarifaiva`),
  ADD UNIQUE KEY `idtarifaiva_UNIQUE` (`idtarifaiva`),
  ADD UNIQUE KEY `nombre_UNIQUE` (`nombre`),
  ADD KEY `fgk_usuario_tarifasiva_idx` (`idusuario`);

--
-- Indices de la tabla `tipos_documento`
--
ALTER TABLE `tipos_documento`
  ADD PRIMARY KEY (`idtipo_documento`),
  ADD UNIQUE KEY `idtipo_documento_UNIQUE` (`idtipo_documento`),
  ADD UNIQUE KEY `prefijo_UNIQUE` (`prefijo`),
  ADD KEY `fgk_usuarios_tipos_documento_idx` (`idusuario`);

--
-- Indices de la tabla `tipos_informe`
--
ALTER TABLE `tipos_informe`
  ADD PRIMARY KEY (`idtipo_informe`),
  ADD UNIQUE KEY `idtipo_informe_facturacion_UNIQUE` (`idtipo_informe`),
  ADD UNIQUE KEY `nombre_UNIQUE` (`nombre`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`idusuario`),
  ADD UNIQUE KEY `idusuario_UNIQUE` (`idusuario`),
  ADD UNIQUE KEY `usuario_UNIQUE` (`usuario`),
  ADD KEY `fgk_roles_usuarios_idx` (`idRol`),
  ADD KEY `fgk_sucurales_usuarios_idx` (`idsucursal`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `articulos`
--
ALTER TABLE `articulos`
  MODIFY `idarticulo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `bodegas`
--
ALTER TABLE `bodegas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `idcliente` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `devoluciones_ventas`
--
ALTER TABLE `devoluciones_ventas`
  MODIFY `iddevolucion_ventas` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `entradas`
--
ALTER TABLE `entradas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `entradas_detalle`
--
ALTER TABLE `entradas_detalle`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `facturas_compra`
--
ALTER TABLE `facturas_compra`
  MODIFY `idfactura_compra` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `facturas_venta`
--
ALTER TABLE `facturas_venta`
  MODIFY `idfactura_venta` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `factura_compra_detalles`
--
ALTER TABLE `factura_compra_detalles`
  MODIFY `idfactura_compra_detalle` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `factura_venta_detalles`
--
ALTER TABLE `factura_venta_detalles`
  MODIFY `idfactura_venta_detalle` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `grupos`
--
ALTER TABLE `grupos`
  MODIFY `idgrupo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `inventario`
--
ALTER TABLE `inventario`
  MODIFY `idinventario` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `listasprecios`
--
ALTER TABLE `listasprecios`
  MODIFY `idlistaprecios` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `marcas`
--
ALTER TABLE `marcas`
  MODIFY `idmarca` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `movimiento_articulos`
--
ALTER TABLE `movimiento_articulos`
  MODIFY `idmovimiento_articulo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `numeracion`
--
ALTER TABLE `numeracion`
  MODIFY `idnumeracion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ordenes_compra`
--
ALTER TABLE `ordenes_compra`
  MODIFY `idorden_compra` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `orden_compra_detalles`
--
ALTER TABLE `orden_compra_detalles`
  MODIFY `idorden_compra_detalle` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `permisos`
--
ALTER TABLE `permisos`
  MODIFY `idpermiso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `precios`
--
ALTER TABLE `precios`
  MODIFY `idprecio` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  MODIFY `idproveedor` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `regimenes`
--
ALTER TABLE `regimenes`
  MODIFY `idregimen` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `idrol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `roles_permisos`
--
ALTER TABLE `roles_permisos`
  MODIFY `idroles_permisos` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `subgrupos`
--
ALTER TABLE `subgrupos`
  MODIFY `idsubgrupo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `sucursales`
--
ALTER TABLE `sucursales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tarifasiva`
--
ALTER TABLE `tarifasiva`
  MODIFY `idtarifaiva` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tipos_documento`
--
ALTER TABLE `tipos_documento`
  MODIFY `idtipo_documento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `tipos_informe`
--
ALTER TABLE `tipos_informe`
  MODIFY `idtipo_informe` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `idusuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `articulos`
--
ALTER TABLE `articulos`
  ADD CONSTRAINT `fgk_grupos_articulos` FOREIGN KEY (`idgrupo`) REFERENCES `grupos` (`idgrupo`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fgk_marcas_articulos` FOREIGN KEY (`idmarca`) REFERENCES `marcas` (`idmarca`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fgk_subgrupos_articulos` FOREIGN KEY (`idsubgrupo`) REFERENCES `subgrupos` (`idsubgrupo`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fgk_tarifasiva_articulos` FOREIGN KEY (`idtarifaiva`) REFERENCES `tarifasiva` (`idtarifaiva`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fgk_usuarios_articulos` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `bodegas`
--
ALTER TABLE `bodegas`
  ADD CONSTRAINT `fgk_sucursales_bodegas` FOREIGN KEY (`idsucursal`) REFERENCES `sucursales` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fgk_usuarios_bodegas` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD CONSTRAINT `fgk_listas_precios_clientes` FOREIGN KEY (`idlistaprecios`) REFERENCES `listasprecios` (`idlistaprecios`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fgk_tipos_documento_clientes` FOREIGN KEY (`idtipo_documento`) REFERENCES `tipos_documento` (`idtipo_documento`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fgk_usuarios_clientes` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `devoluciones_ventas`
--
ALTER TABLE `devoluciones_ventas`
  ADD CONSTRAINT `fgk_bodegas_devoluciones_ventas` FOREIGN KEY (`idbodega`) REFERENCES `bodegas` (`id`),
  ADD CONSTRAINT `fgk_factura_venta_detalles_devolucione_ventas` FOREIGN KEY (`idfactura_venta_detalle`) REFERENCES `factura_venta_detalles` (`idfactura_venta_detalle`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `entradas`
--
ALTER TABLE `entradas`
  ADD CONSTRAINT `fgk_usuarios_entradas` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `entradas_detalle`
--
ALTER TABLE `entradas_detalle`
  ADD CONSTRAINT `fgk_bodegas_entradas_detalle` FOREIGN KEY (`idbodega`) REFERENCES `bodegas` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fgk_entradas_entradas_detalle` FOREIGN KEY (`identrada`) REFERENCES `entradas` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fgk_tarifaiva_entradas_detalle` FOREIGN KEY (`idtarifaiva`) REFERENCES `tarifasiva` (`idtarifaiva`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `facturas_compra`
--
ALTER TABLE `facturas_compra`
  ADD CONSTRAINT `fgk_proveedores_facturas_compra` FOREIGN KEY (`idproveedor`) REFERENCES `proveedores` (`idproveedor`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fgk_usuarios_facturas_compra` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `facturas_venta`
--
ALTER TABLE `facturas_venta`
  ADD CONSTRAINT `fgk_clientes_facturas_venta` FOREIGN KEY (`idcliente`) REFERENCES `clientes` (`idcliente`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fgk_numeracion_facturas_venta` FOREIGN KEY (`prefijo`) REFERENCES `numeracion` (`prefijo`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fgk_usuarios_facturas_venta` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `factura_compra_detalles`
--
ALTER TABLE `factura_compra_detalles`
  ADD CONSTRAINT `fgk_articulos_orden_factura_detalles` FOREIGN KEY (`codigoarticulo`) REFERENCES `articulos` (`codigo`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fgk_facturas_compra_factura_compra_detalles` FOREIGN KEY (`idfactura_compra`) REFERENCES `facturas_compra` (`idfactura_compra`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fgk_tarifasiva_factura_compra_detalles` FOREIGN KEY (`idtarifaiva`) REFERENCES `tarifasiva` (`idtarifaiva`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `factura_venta_detalles`
--
ALTER TABLE `factura_venta_detalles`
  ADD CONSTRAINT `fgk_articulos_factura_venta_detalles` FOREIGN KEY (`codigoarticulo`) REFERENCES `articulos` (`codigo`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fgk_bodegas_factura_venta` FOREIGN KEY (`idbodega`) REFERENCES `bodegas` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fgk_facturas_venta_factura_venta_detalles` FOREIGN KEY (`idfactura_venta`) REFERENCES `facturas_venta` (`idfactura_venta`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fgk_tarifasiva_factura_venta_detalles` FOREIGN KEY (`idtarifaiva`) REFERENCES `tarifasiva` (`idtarifaiva`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `grupos`
--
ALTER TABLE `grupos`
  ADD CONSTRAINT `fgk_usuarios_grupos` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `inventario`
--
ALTER TABLE `inventario`
  ADD CONSTRAINT `fgk_articulos_inventario` FOREIGN KEY (`idarticulo`) REFERENCES `articulos` (`idarticulo`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fgk_bodegas_inventario` FOREIGN KEY (`idbodega`) REFERENCES `bodegas` (`id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `listasprecios`
--
ALTER TABLE `listasprecios`
  ADD CONSTRAINT `fgk_usuarios_listasprecios` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `movimiento_articulos`
--
ALTER TABLE `movimiento_articulos`
  ADD CONSTRAINT `fgk_articulos_movimiento_articulos` FOREIGN KEY (`idarticulo`) REFERENCES `articulos` (`idarticulo`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fgk_bodegas_movimiento_articulos` FOREIGN KEY (`idbodega`) REFERENCES `bodegas` (`id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `numeracion`
--
ALTER TABLE `numeracion`
  ADD CONSTRAINT `fgk_usuarios_numeracion` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `ordenes_compra`
--
ALTER TABLE `ordenes_compra`
  ADD CONSTRAINT `fgk_proveedores_ordenes_compra` FOREIGN KEY (`idproveedor`) REFERENCES `proveedores` (`idproveedor`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fgk_usuarios_ordenes_compra` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `orden_compra_detalles`
--
ALTER TABLE `orden_compra_detalles`
  ADD CONSTRAINT `fgk_articulos_orden_compra_detalles` FOREIGN KEY (`codigoarticulo`) REFERENCES `articulos` (`codigo`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fgk_ordenes_compra_orden_compra_detalles` FOREIGN KEY (`idorden_compra`) REFERENCES `ordenes_compra` (`idorden_compra`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fgk_tarifasiva_orden_compra_detalles` FOREIGN KEY (`idtarifaiva`) REFERENCES `tarifasiva` (`idtarifaiva`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `precios`
--
ALTER TABLE `precios`
  ADD CONSTRAINT `fgk_articulos_precios` FOREIGN KEY (`idarticulo`) REFERENCES `articulos` (`idarticulo`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fgk_listasprecios_precios` FOREIGN KEY (`idlistaprecios`) REFERENCES `listasprecios` (`idlistaprecios`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fgk_usuarios_precios` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `proveedores`
--
ALTER TABLE `proveedores`
  ADD CONSTRAINT `fgk_regimenes_proveedor` FOREIGN KEY (`idregimen`) REFERENCES `regimenes` (`idregimen`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fgk_tipo_documento_proveedores` FOREIGN KEY (`idtipo_documento`) REFERENCES `tipos_documento` (`idtipo_documento`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fgk_usuario_proveedores` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `regimenes`
--
ALTER TABLE `regimenes`
  ADD CONSTRAINT `fgk_usuario_regimenes` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `roles_permisos`
--
ALTER TABLE `roles_permisos`
  ADD CONSTRAINT `fgk_permisos_roles_permisos` FOREIGN KEY (`idpermiso`) REFERENCES `permisos` (`idpermiso`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fgk_roles_roles_permisos` FOREIGN KEY (`idrol`) REFERENCES `roles` (`idrol`);

--
-- Filtros para la tabla `subgrupos`
--
ALTER TABLE `subgrupos`
  ADD CONSTRAINT `fgk_grupos_subgrupos` FOREIGN KEY (`idgrupo`) REFERENCES `grupos` (`idgrupo`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fgk_usuarios_subgrupos` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `sucursales`
--
ALTER TABLE `sucursales`
  ADD CONSTRAINT `fgk_usuarios_sucursales` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tarifasiva`
--
ALTER TABLE `tarifasiva`
  ADD CONSTRAINT `fgk_usuario_tarifasiva` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tipos_documento`
--
ALTER TABLE `tipos_documento`
  ADD CONSTRAINT `fgk_usuarios_tipos_documento` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fgk_roles_usuarios` FOREIGN KEY (`idRol`) REFERENCES `roles` (`idrol`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fgk_sucurales_usuarios` FOREIGN KEY (`idsucursal`) REFERENCES `sucursales` (`id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
