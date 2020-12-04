-- MySQL dump 10.13  Distrib 8.0.20, for Win64 (x86_64)
--
-- Host: localhost    Database: soltec
-- ------------------------------------------------------
-- Server version	8.0.20

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `articulos`
--

DROP TABLE IF EXISTS `articulos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `articulos` (
  `idarticulo` int NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(150) NOT NULL,
  `codigo` varchar(20) NOT NULL,
  `idtarifaiva` int NOT NULL,
  `idgrupo` int NOT NULL,
  `idsubgrupo` int NOT NULL,
  `idmarca` int NOT NULL,
  `idusuario` int NOT NULL,
  `fechacreacion` datetime NOT NULL,
  `estado` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`idarticulo`),
  UNIQUE KEY `idarticulo_UNIQUE` (`idarticulo`),
  UNIQUE KEY `codigo_UNIQUE` (`codigo`),
  KEY `fgk_tarifasiva_articulos_idx` (`idtarifaiva`),
  KEY `fgk_grupos_articulos_idx` (`idgrupo`),
  KEY `fgk_subgrupos_articulos_idx` (`idsubgrupo`),
  KEY `fgk_marcas_articulos_idx` (`idmarca`),
  KEY `fgk_usuarios_articulos_idx` (`idusuario`),
  CONSTRAINT `fgk_grupos_articulos` FOREIGN KEY (`idgrupo`) REFERENCES `grupos` (`idgrupo`) ON UPDATE CASCADE,
  CONSTRAINT `fgk_marcas_articulos` FOREIGN KEY (`idmarca`) REFERENCES `marcas` (`idmarca`) ON UPDATE CASCADE,
  CONSTRAINT `fgk_subgrupos_articulos` FOREIGN KEY (`idsubgrupo`) REFERENCES `subgrupos` (`idsubgrupo`) ON UPDATE CASCADE,
  CONSTRAINT `fgk_tarifasiva_articulos` FOREIGN KEY (`idtarifaiva`) REFERENCES `tarifasiva` (`idtarifaiva`) ON UPDATE CASCADE,
  CONSTRAINT `fgk_usuarios_articulos` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2408 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `articulos`
--

LOCK TABLES `articulos` WRITE;
/*!40000 ALTER TABLE `articulos` DISABLE KEYS */;
/*!40000 ALTER TABLE `articulos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bodegas`
--

DROP TABLE IF EXISTS `bodegas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bodegas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(20) NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT '1',
  `idsucursal` int NOT NULL,
  `principal` tinyint(1) NOT NULL DEFAULT '0',
  `idusuario` int DEFAULT NULL,
  `fechacreacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`),
  KEY `fgk_sucursales_bodegas` (`idsucursal`),
  KEY `fgk_usuarios_bodegas` (`idusuario`),
  CONSTRAINT `fgk_sucursales_bodegas` FOREIGN KEY (`idsucursal`) REFERENCES `sucursales` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fgk_usuarios_bodegas` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bodegas`
--

LOCK TABLES `bodegas` WRITE;
/*!40000 ALTER TABLE `bodegas` DISABLE KEYS */;
INSERT INTO `bodegas` VALUES (1,'NUEVA',1,2,0,1,'2020-12-03 23:25:54');
/*!40000 ALTER TABLE `bodegas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `idcliente` int NOT NULL AUTO_INCREMENT,
  `nombres` varchar(60) NOT NULL,
  `apellidos` varchar(60) NOT NULL,
  `documento` varchar(10) NOT NULL,
  `direccion` varchar(100) DEFAULT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `idtipo_documento` int NOT NULL,
  `idlistaprecios` int NOT NULL,
  `idusuario` int NOT NULL,
  `fechacreacion` datetime NOT NULL,
  PRIMARY KEY (`idcliente`),
  UNIQUE KEY `idcliente_UNIQUE` (`idcliente`),
  UNIQUE KEY `documento_UNIQUE` (`documento`),
  KEY `fgk_tipos_documento_clientes_idx` (`idtipo_documento`),
  KEY `fgk_usuarios_clientes_idx` (`idusuario`),
  KEY `fgk_listas_precios_clientes_idx` (`idlistaprecios`),
  CONSTRAINT `fgk_listas_precios_clientes` FOREIGN KEY (`idlistaprecios`) REFERENCES `listasprecios` (`idlistaprecios`) ON UPDATE CASCADE,
  CONSTRAINT `fgk_tipos_documento_clientes` FOREIGN KEY (`idtipo_documento`) REFERENCES `tipos_documento` (`idtipo_documento`) ON UPDATE CASCADE,
  CONSTRAINT `fgk_usuarios_clientes` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'CLIENTE','OCACIONAL','1','NO APLICASS','0',1,1,1,'2020-07-19 07:07:48');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `devoluciones_ventas`
--

DROP TABLE IF EXISTS `devoluciones_ventas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `devoluciones_ventas` (
  `iddevolucion_ventas` int NOT NULL AUTO_INCREMENT,
  `idfactura_venta_detalle` int NOT NULL,
  `estado` tinyint NOT NULL DEFAULT '1',
  `idusuario` int NOT NULL,
  `fechacreacion` datetime NOT NULL,
  PRIMARY KEY (`iddevolucion_ventas`),
  UNIQUE KEY `iddevolucion_ventas_UNIQUE` (`iddevolucion_ventas`),
  KEY `fgk_factura_venta_detalles_devolucione_ventas_idx` (`idfactura_venta_detalle`),
  CONSTRAINT `fgk_factura_venta_detalles_devolucione_ventas` FOREIGN KEY (`idfactura_venta_detalle`) REFERENCES `factura_venta_detalles` (`idfactura_venta_detalle`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devoluciones_ventas`
--

LOCK TABLES `devoluciones_ventas` WRITE;
/*!40000 ALTER TABLE `devoluciones_ventas` DISABLE KEYS */;
/*!40000 ALTER TABLE `devoluciones_ventas` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ajuste_inventarios` AFTER INSERT ON `devoluciones_ventas` FOR EACH ROW BEGIN
	SET @IDFACTURA = (SELECT idfactura_venta FROM factura_venta_detalles WHERE idfactura_venta_detalle = NEW.idfactura_venta_detalle);
    SET @CODIGO = (SELECT codigoarticulo FROM factura_venta_detalles WHERE idfactura_venta_detalle = NEW.idfactura_venta_detalle);
    SET @IDARTICULO = (SELECT idarticulo FROM articulos WHERE codigo=@CODIGO);
    SET @ID =  (SELECT idinventario FROM inventario WHERE idarticulo = @IDARTICULO);
	SET @CANTIDAD = (SELECT cantidadarticulo FROM factura_venta_detalles WHERE idfactura_venta_detalle = NEW.idfactura_venta_detalle);
    
    UPDATE facturas_venta SET iddevolucion_ventas = NEW.iddevolucion_ventas WHERE idfactura_venta = @IDFACTURA;
	INSERT INTO movimiento_articulos SET idarticulo = @IDARTICULO, tipomovimiento='E',cantidad= @CANTIDAD, fechacreacion=NOW();
    UPDATE inventario SET cantidad = cantidad +@CANTIDAD WHERE idinventario = @ID;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `entradas`
--

DROP TABLE IF EXISTS `entradas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entradas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idusuario` int NOT NULL,
  `fechacreacion` datetime NOT NULL,
  `estado` tinyint(1) NOT NULL,
  `observacion` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fgk_usuarios_entradas` (`idusuario`),
  CONSTRAINT `fgk_usuarios_entradas` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entradas`
--

LOCK TABLES `entradas` WRITE;
/*!40000 ALTER TABLE `entradas` DISABLE KEYS */;
/*!40000 ALTER TABLE `entradas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entradas_detalle`
--

DROP TABLE IF EXISTS `entradas_detalle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entradas_detalle` (
  `id` int NOT NULL AUTO_INCREMENT,
  `identrada` int NOT NULL,
  `codigoarticulo` varchar(20) NOT NULL,
  `descripcionarticulo` varchar(150) NOT NULL,
  `cantidadarticulo` double NOT NULL,
  `valorarticulo` double NOT NULL,
  `ivaarticulo` double NOT NULL,
  `idtarifaiva` int NOT NULL,
  `idbodega` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fgk_bodegas_entradas_detalle` (`idbodega`),
  KEY `fgk_entradas_entradas_detalle` (`identrada`),
  KEY `fgk_tarifaiva_entradas_detalle` (`idtarifaiva`),
  CONSTRAINT `fgk_bodegas_entradas_detalle` FOREIGN KEY (`idbodega`) REFERENCES `bodegas` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fgk_entradas_entradas_detalle` FOREIGN KEY (`identrada`) REFERENCES `entradas` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fgk_tarifaiva_entradas_detalle` FOREIGN KEY (`idtarifaiva`) REFERENCES `tarifasiva` (`idtarifaiva`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entradas_detalle`
--

LOCK TABLES `entradas_detalle` WRITE;
/*!40000 ALTER TABLE `entradas_detalle` DISABLE KEYS */;
/*!40000 ALTER TABLE `entradas_detalle` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `inventario_entrada` BEFORE INSERT ON `entradas_detalle` FOR EACH ROW BEGIN 
SET @IDARTICULO = (SELECT idarticulo FROM articulos WHERE codigo = NEW.codigoarticulo);

SET @ID = (SELECT idinventario FROM inventario WHERE idarticulo = @IDARTICULO AND idbodega = NEW.idbodega);

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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `factura_compra_detalles`
--

DROP TABLE IF EXISTS `factura_compra_detalles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `factura_compra_detalles` (
  `idfactura_compra_detalle` int NOT NULL AUTO_INCREMENT,
  `codigoarticulo` varchar(20) NOT NULL,
  `descripcionarticulo` varchar(150) NOT NULL,
  `cantidadarticulo` double NOT NULL,
  `valorarticulo` double NOT NULL,
  `ivaarticulo` double NOT NULL DEFAULT '0',
  `idtarifaiva` int NOT NULL,
  `idfactura_compra` int NOT NULL,
  PRIMARY KEY (`idfactura_compra_detalle`),
  UNIQUE KEY `idfactura_compra_detalle_UNIQUE` (`idfactura_compra_detalle`),
  KEY `fgk_articulos_factura_compra_detalles_idx` (`codigoarticulo`),
  KEY `fgk_tarifasiva_factura_compra_detalles_idx` (`idtarifaiva`),
  KEY `fgk_facturas_compra_factura_compra_detalles_idx` (`idfactura_compra`),
  CONSTRAINT `fgk_articulos_orden_factura_detalles` FOREIGN KEY (`codigoarticulo`) REFERENCES `articulos` (`codigo`) ON UPDATE CASCADE,
  CONSTRAINT `fgk_facturas_compra_factura_compra_detalles` FOREIGN KEY (`idfactura_compra`) REFERENCES `facturas_compra` (`idfactura_compra`) ON UPDATE CASCADE,
  CONSTRAINT `fgk_tarifasiva_factura_compra_detalles` FOREIGN KEY (`idtarifaiva`) REFERENCES `tarifasiva` (`idtarifaiva`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `factura_compra_detalles`
--

LOCK TABLES `factura_compra_detalles` WRITE;
/*!40000 ALTER TABLE `factura_compra_detalles` DISABLE KEYS */;
/*!40000 ALTER TABLE `factura_compra_detalles` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `mov_inventario_compra` AFTER INSERT ON `factura_compra_detalles` FOR EACH ROW BEGIN
	SET @IDARTICULO = (SELECT idarticulo FROM articulos WHERE codigo=NEW.codigoarticulo);
	SET @ID =  (SELECT idinventario FROM inventario WHERE idarticulo = @IDARTICULO);
    INSERT INTO movimiento_articulos SET idarticulo = @IDARTICULO, tipomovimiento='E',cantidad= NEW.cantidadarticulo,fechacreacion=NOW();
    IF @ID>0 THEN
    UPDATE inventario SET cantidad = cantidad + NEW.cantidadarticulo, costopromedio = (costopromedio+NEW.valorarticulo)/2, ultimocosto=NEW.valorarticulo WHERE idinventario = @ID;
    ELSE
    INSERT INTO inventario(idarticulo,cantidad, costopromedio,ultimocosto) VALUES(@IDARTICULO,NEW.cantidadarticulo,NEW.valorarticulo,NEW.valorarticulo);
    END IF;
    
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `factura_venta_detalles`
--

DROP TABLE IF EXISTS `factura_venta_detalles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `factura_venta_detalles` (
  `idfactura_venta_detalle` int NOT NULL AUTO_INCREMENT,
  `codigoarticulo` varchar(20) NOT NULL,
  `descripcionarticulo` varchar(150) NOT NULL,
  `cantidadarticulo` double NOT NULL,
  `valorarticulo` double NOT NULL,
  `ivaarticulo` double NOT NULL DEFAULT '0',
  `idtarifaiva` int NOT NULL,
  `idfactura_venta` int NOT NULL,
  `idbodega` int DEFAULT NULL,
  PRIMARY KEY (`idfactura_venta_detalle`),
  UNIQUE KEY `idfactura_venta_detalle_UNIQUE` (`idfactura_venta_detalle`),
  KEY `fgk_articulos_factura_venta_detalles_idx` (`codigoarticulo`),
  KEY `fgk_tarifasiva_factura_venta_detalles_idx` (`idtarifaiva`),
  KEY `fgk_facturas_venta_factura_venta_detalles_idx` (`idfactura_venta`),
  CONSTRAINT `fgk_articulos_factura_venta_detalles` FOREIGN KEY (`codigoarticulo`) REFERENCES `articulos` (`codigo`) ON UPDATE CASCADE,
  CONSTRAINT `fgk_facturas_venta_factura_venta_detalles` FOREIGN KEY (`idfactura_venta`) REFERENCES `facturas_venta` (`idfactura_venta`) ON UPDATE CASCADE,
  CONSTRAINT `fgk_tarifasiva_factura_venta_detalles` FOREIGN KEY (`idtarifaiva`) REFERENCES `tarifasiva` (`idtarifaiva`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13169 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `factura_venta_detalles`
--

LOCK TABLES `factura_venta_detalles` WRITE;
/*!40000 ALTER TABLE `factura_venta_detalles` DISABLE KEYS */;
/*!40000 ALTER TABLE `factura_venta_detalles` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `mov_inventario_ventas` AFTER INSERT ON `factura_venta_detalles` FOR EACH ROW BEGIN
	SET @IDARTICULO = (SELECT idarticulo FROM articulos WHERE codigo=NEW.codigoarticulo);
	SET @ID =  (SELECT idinventario FROM inventario WHERE idarticulo = @IDARTICULO AND idbodega = NEW.idbodega);
    INSERT INTO movimiento_articulos SET idarticulo = @IDARTICULO, tipomovimiento='S',cantidad= NEW.cantidadarticulo, fechacreacion=NOW(),idbodega=new.idbodega;
    IF @ID>0 THEN
		UPDATE inventario SET cantidad = cantidad -NEW.cantidadarticulo WHERE idinventario = @ID;
    ELSE
		INSERT INTO inventario(idarticulo,cantidad, costopromedio,ultimocosto,idbodega) VALUES(@IDARTICULO,-NEW.cantidadarticulo,0,0,new.idbodega);
    END IF;
    
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `facturas_compra`
--

DROP TABLE IF EXISTS `facturas_compra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facturas_compra` (
  `idfactura_compra` int NOT NULL AUTO_INCREMENT,
  `idproveedor` int NOT NULL,
  `idusuario` int NOT NULL,
  `fechacreacion` datetime NOT NULL,
  `estado` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`idfactura_compra`),
  UNIQUE KEY `idfactura_compra_UNIQUE` (`idfactura_compra`),
  KEY `fgk_proveedores_facturas_compra_idx` (`idproveedor`),
  KEY `fgk_usuarios_facturas_compra_idx` (`idusuario`),
  CONSTRAINT `fgk_proveedores_facturas_compra` FOREIGN KEY (`idproveedor`) REFERENCES `proveedores` (`idproveedor`) ON UPDATE CASCADE,
  CONSTRAINT `fgk_usuarios_facturas_compra` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facturas_compra`
--

LOCK TABLES `facturas_compra` WRITE;
/*!40000 ALTER TABLE `facturas_compra` DISABLE KEYS */;
/*!40000 ALTER TABLE `facturas_compra` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `facturas_venta`
--

DROP TABLE IF EXISTS `facturas_venta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facturas_venta` (
  `idfactura_venta` int NOT NULL AUTO_INCREMENT,
  `idcliente` int NOT NULL,
  `idusuario` int NOT NULL,
  `fechacreacion` datetime NOT NULL,
  `estado` tinyint NOT NULL DEFAULT '1',
  `prefijo` varchar(5) NOT NULL,
  `numero` int NOT NULL,
  `iddevolucion_ventas` int DEFAULT NULL,
  `recibido` double NOT NULL,
  PRIMARY KEY (`idfactura_venta`),
  UNIQUE KEY `idfactura_venta_UNIQUE` (`idfactura_venta`),
  KEY `fgk_clientes_facturas_venta_idx` (`idcliente`),
  KEY `fgk_usuarios_facturas_venta_idx` (`idusuario`),
  KEY `fgk_numeracion_facturas_venta_idx` (`prefijo`),
  CONSTRAINT `fgk_clientes_facturas_venta` FOREIGN KEY (`idcliente`) REFERENCES `clientes` (`idcliente`) ON UPDATE CASCADE,
  CONSTRAINT `fgk_numeracion_facturas_venta` FOREIGN KEY (`prefijo`) REFERENCES `numeracion` (`prefijo`) ON UPDATE CASCADE,
  CONSTRAINT `fgk_usuarios_facturas_venta` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6907 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facturas_venta`
--

LOCK TABLES `facturas_venta` WRITE;
/*!40000 ALTER TABLE `facturas_venta` DISABLE KEYS */;
/*!40000 ALTER TABLE `facturas_venta` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `facturas_venta_AFTER_INSERT` AFTER INSERT ON `facturas_venta` FOR EACH ROW BEGIN
	UPDATE numeracion SET numero = numero+1 WHERE prefijo = NEW.prefijo;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `grupos`
--

DROP TABLE IF EXISTS `grupos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grupos` (
  `idgrupo` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  `idusuario` int NOT NULL,
  `fechacreacion` datetime NOT NULL,
  PRIMARY KEY (`idgrupo`),
  UNIQUE KEY `idgrupo_UNIQUE` (`idgrupo`),
  UNIQUE KEY `nombre_UNIQUE` (`nombre`),
  KEY `fgk_usuarios_grupos_idx` (`idusuario`),
  CONSTRAINT `fgk_usuarios_grupos` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grupos`
--

LOCK TABLES `grupos` WRITE;
/*!40000 ALTER TABLE `grupos` DISABLE KEYS */;
/*!40000 ALTER TABLE `grupos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventario`
--

DROP TABLE IF EXISTS `inventario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventario` (
  `idinventario` int NOT NULL AUTO_INCREMENT,
  `idarticulo` int NOT NULL,
  `cantidad` double NOT NULL,
  `costopromedio` double NOT NULL,
  `ultimocosto` double NOT NULL,
  `idbodega` int NOT NULL,
  PRIMARY KEY (`idinventario`),
  UNIQUE KEY `idinventario_UNIQUE` (`idinventario`),
  KEY `fgk_articulos_inventario_idx` (`idarticulo`),
  KEY `fgk_bodegas_inventarios_idx` (`idbodega`),
  CONSTRAINT `fgk_articulos_inventario` FOREIGN KEY (`idarticulo`) REFERENCES `articulos` (`idarticulo`) ON UPDATE CASCADE,
  CONSTRAINT `fgk_bodegas_inventarios` FOREIGN KEY (`idbodega`) REFERENCES `bodegas` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=525 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventario`
--

LOCK TABLES `inventario` WRITE;
/*!40000 ALTER TABLE `inventario` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `listasprecios`
--

DROP TABLE IF EXISTS `listasprecios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `listasprecios` (
  `idlistaprecios` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  `fechacreacion` datetime NOT NULL,
  `idusuario` int NOT NULL,
  PRIMARY KEY (`idlistaprecios`),
  UNIQUE KEY `idlistaprecios_UNIQUE` (`idlistaprecios`),
  UNIQUE KEY `nombre_UNIQUE` (`nombre`),
  KEY `fgk_usuarios_listasprecios_idx` (`idusuario`),
  CONSTRAINT `fgk_usuarios_listasprecios` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listasprecios`
--

LOCK TABLES `listasprecios` WRITE;
/*!40000 ALTER TABLE `listasprecios` DISABLE KEYS */;
INSERT INTO `listasprecios` VALUES (1,'GENERAL','2020-07-19 06:18:04',1);
/*!40000 ALTER TABLE `listasprecios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marcas`
--

DROP TABLE IF EXISTS `marcas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `marcas` (
  `idmarca` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  `idusuario` int NOT NULL,
  `fechacreacion` datetime NOT NULL,
  PRIMARY KEY (`idmarca`),
  UNIQUE KEY `idmarca_UNIQUE` (`idmarca`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marcas`
--

LOCK TABLES `marcas` WRITE;
/*!40000 ALTER TABLE `marcas` DISABLE KEYS */;
/*!40000 ALTER TABLE `marcas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movimiento_articulos`
--

DROP TABLE IF EXISTS `movimiento_articulos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movimiento_articulos` (
  `idmovimiento_articulo` int NOT NULL AUTO_INCREMENT,
  `idarticulo` int NOT NULL,
  `tipomovimiento` varchar(1) NOT NULL,
  `cantidad` double NOT NULL,
  `fechacreacion` datetime NOT NULL,
  `idbodega` int NOT NULL,
  PRIMARY KEY (`idmovimiento_articulo`),
  UNIQUE KEY `idmovimiento_articulo_UNIQUE` (`idmovimiento_articulo`),
  KEY `fgk_articulos_movimiento_articulos_idx` (`idarticulo`),
  KEY `fgk_bodegas_movimiento_articulos_idx` (`idbodega`),
  CONSTRAINT `fgk_articulos_movimiento_articulos` FOREIGN KEY (`idarticulo`) REFERENCES `articulos` (`idarticulo`) ON UPDATE CASCADE,
  CONSTRAINT `fgk_bodegas_movimiento_articulos` FOREIGN KEY (`idbodega`) REFERENCES `bodegas` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13180 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movimiento_articulos`
--

LOCK TABLES `movimiento_articulos` WRITE;
/*!40000 ALTER TABLE `movimiento_articulos` DISABLE KEYS */;
/*!40000 ALTER TABLE `movimiento_articulos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `numeracion`
--

DROP TABLE IF EXISTS `numeracion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `numeracion` (
  `idnumeracion` int NOT NULL AUTO_INCREMENT,
  `prefijo` varchar(5) NOT NULL,
  `numero` int NOT NULL,
  `autorizacion` varchar(50) DEFAULT NULL,
  `fechaautorizacion` date DEFAULT NULL,
  `fechavencimiento` date DEFAULT NULL,
  `idusuario` int DEFAULT NULL,
  `extension` tinyint NOT NULL DEFAULT '0',
  `fechacreacion` datetime NOT NULL,
  `idsucursal` int NOT NULL,
  PRIMARY KEY (`idnumeracion`),
  UNIQUE KEY `idnumeracion_UNIQUE` (`idnumeracion`),
  UNIQUE KEY `prefijo_UNIQUE` (`prefijo`),
  KEY `fgk_usuarios_numeracion_idx` (`idusuario`),
  KEY `fgk_sucursales_numeracion_idx` (`idsucursal`),
  CONSTRAINT `fgk_sucursales_numeracion` FOREIGN KEY (`idsucursal`) REFERENCES `sucursales` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fgk_usuarios_numeracion` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `numeracion`
--

LOCK TABLES `numeracion` WRITE;
/*!40000 ALTER TABLE `numeracion` DISABLE KEYS */;
/*!40000 ALTER TABLE `numeracion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orden_compra_detalles`
--

DROP TABLE IF EXISTS `orden_compra_detalles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orden_compra_detalles` (
  `idorden_compra_detalle` int NOT NULL AUTO_INCREMENT,
  `codigoarticulo` varchar(20) NOT NULL,
  `descripcionarticulo` varchar(150) NOT NULL,
  `cantidadarticulo` double NOT NULL,
  `valorarticulo` double NOT NULL,
  `ivaarticulo` double NOT NULL DEFAULT '0',
  `idtarifaiva` int NOT NULL,
  `idorden_compra` int NOT NULL,
  PRIMARY KEY (`idorden_compra_detalle`),
  UNIQUE KEY `idorden_compra_detalle_UNIQUE` (`idorden_compra_detalle`),
  KEY `fgk_articulos_orden_compra_detalles_idx` (`codigoarticulo`),
  KEY `fgk_tarifasiva_orden_compra_detalles_idx` (`idtarifaiva`),
  KEY `fgk_ordenes_compra_orden_compra_detalles_idx` (`idorden_compra`),
  CONSTRAINT `fgk_articulos_orden_compra_detalles` FOREIGN KEY (`codigoarticulo`) REFERENCES `articulos` (`codigo`) ON UPDATE CASCADE,
  CONSTRAINT `fgk_ordenes_compra_orden_compra_detalles` FOREIGN KEY (`idorden_compra`) REFERENCES `ordenes_compra` (`idorden_compra`) ON UPDATE CASCADE,
  CONSTRAINT `fgk_tarifasiva_orden_compra_detalles` FOREIGN KEY (`idtarifaiva`) REFERENCES `tarifasiva` (`idtarifaiva`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orden_compra_detalles`
--

LOCK TABLES `orden_compra_detalles` WRITE;
/*!40000 ALTER TABLE `orden_compra_detalles` DISABLE KEYS */;
/*!40000 ALTER TABLE `orden_compra_detalles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ordenes_compra`
--

DROP TABLE IF EXISTS `ordenes_compra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordenes_compra` (
  `idorden_compra` int NOT NULL AUTO_INCREMENT,
  `idproveedor` int NOT NULL,
  `idusuario` int NOT NULL,
  `fechacreacion` datetime NOT NULL,
  `estado` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`idorden_compra`),
  UNIQUE KEY `idorden_compra_UNIQUE` (`idorden_compra`),
  KEY `fgk_proveedores_ordenes_compra_idx` (`idproveedor`),
  KEY `fgk_usuarios_ordenes_compra_idx` (`idusuario`),
  CONSTRAINT `fgk_proveedores_ordenes_compra` FOREIGN KEY (`idproveedor`) REFERENCES `proveedores` (`idproveedor`) ON UPDATE CASCADE,
  CONSTRAINT `fgk_usuarios_ordenes_compra` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ordenes_compra`
--

LOCK TABLES `ordenes_compra` WRITE;
/*!40000 ALTER TABLE `ordenes_compra` DISABLE KEYS */;
/*!40000 ALTER TABLE `ordenes_compra` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permisos`
--

DROP TABLE IF EXISTS `permisos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permisos` (
  `idpermiso` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) DEFAULT NULL,
  `detalle` varchar(150) DEFAULT NULL,
  `modulo` varchar(20) NOT NULL,
  `fechacreacion` date NOT NULL,
  PRIMARY KEY (`idpermiso`),
  UNIQUE KEY `idpermiso_UNIQUE` (`idpermiso`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permisos`
--

LOCK TABLES `permisos` WRITE;
/*!40000 ALTER TABLE `permisos` DISABLE KEYS */;
/*!40000 ALTER TABLE `permisos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `precios`
--

DROP TABLE IF EXISTS `precios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `precios` (
  `idprecio` int NOT NULL AUTO_INCREMENT,
  `idlistaprecios` int NOT NULL,
  `idarticulo` int NOT NULL,
  `idusuario` int NOT NULL,
  `fechacreacion` datetime NOT NULL,
  `valor` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`idprecio`),
  UNIQUE KEY `idprecio_UNIQUE` (`idprecio`),
  KEY `fgk_listasprecios_idx` (`idlistaprecios`),
  KEY `fgk_articulos_precios_idx` (`idarticulo`),
  KEY `fgk_usuarios_precios_idx` (`idusuario`),
  CONSTRAINT `fgk_articulos_precios` FOREIGN KEY (`idarticulo`) REFERENCES `articulos` (`idarticulo`) ON UPDATE CASCADE,
  CONSTRAINT `fgk_listasprecios_precios` FOREIGN KEY (`idlistaprecios`) REFERENCES `listasprecios` (`idlistaprecios`) ON UPDATE CASCADE,
  CONSTRAINT `fgk_usuarios_precios` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1259 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `precios`
--

LOCK TABLES `precios` WRITE;
/*!40000 ALTER TABLE `precios` DISABLE KEYS */;
/*!40000 ALTER TABLE `precios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proveedores`
--

DROP TABLE IF EXISTS `proveedores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proveedores` (
  `idproveedor` int NOT NULL AUTO_INCREMENT,
  `idtipo_documento` int NOT NULL,
  `documento` varchar(15) NOT NULL,
  `razonsocial` varchar(100) NOT NULL,
  `nombres` varchar(30) NOT NULL,
  `apellidos` varchar(30) NOT NULL,
  `direccion` varchar(100) DEFAULT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `correo` varchar(45) DEFAULT NULL,
  `idregimen` int NOT NULL,
  `idusuario` int NOT NULL,
  `fechacreacion` datetime NOT NULL,
  PRIMARY KEY (`idproveedor`),
  UNIQUE KEY `idproveedor_UNIQUE` (`idproveedor`),
  UNIQUE KEY `documento_UNIQUE` (`documento`),
  KEY `fgk_tipo_documento_proveedores_idx` (`idtipo_documento`),
  KEY `fgk_regimenes_proveedor_idx` (`idregimen`),
  KEY `fgk_usuario_proveedores_idx` (`idusuario`),
  CONSTRAINT `fgk_regimenes_proveedor` FOREIGN KEY (`idregimen`) REFERENCES `regimenes` (`idregimen`) ON UPDATE CASCADE,
  CONSTRAINT `fgk_tipo_documento_proveedores` FOREIGN KEY (`idtipo_documento`) REFERENCES `tipos_documento` (`idtipo_documento`) ON UPDATE CASCADE,
  CONSTRAINT `fgk_usuario_proveedores` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proveedores`
--

LOCK TABLES `proveedores` WRITE;
/*!40000 ALTER TABLE `proveedores` DISABLE KEYS */;
/*!40000 ALTER TABLE `proveedores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `regimenes`
--

DROP TABLE IF EXISTS `regimenes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `regimenes` (
  `idregimen` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  `idusuario` int NOT NULL,
  `fechacreacion` datetime NOT NULL,
  PRIMARY KEY (`idregimen`),
  UNIQUE KEY `idregimen_UNIQUE` (`idregimen`),
  UNIQUE KEY `nombre_UNIQUE` (`nombre`),
  KEY `fgk_usuario_regimenes_idx` (`idusuario`),
  CONSTRAINT `fgk_usuario_regimenes` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `regimenes`
--

LOCK TABLES `regimenes` WRITE;
/*!40000 ALTER TABLE `regimenes` DISABLE KEYS */;
INSERT INTO `regimenes` VALUES (1,'SIMPLIFICADO',1,'2020-07-19 06:06:06'),(2,'COMUN',1,'2020-07-19 06:05:02');
/*!40000 ALTER TABLE `regimenes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `idrol` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  `fechacreacion` date NOT NULL,
  PRIMARY KEY (`idrol`),
  UNIQUE KEY `idrol_UNIQUE` (`idrol`),
  UNIQUE KEY `nombre_UNIQUE` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='se encarga de guardar los roles de los usuarios';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (2,'ADMINISTRADOR','2020-11-30');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles_permisos`
--

DROP TABLE IF EXISTS `roles_permisos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles_permisos` (
  `idroles_permisos` int NOT NULL AUTO_INCREMENT,
  `idrol` int NOT NULL,
  `idpermiso` int NOT NULL,
  `fechacreacion` datetime NOT NULL,
  PRIMARY KEY (`idroles_permisos`),
  UNIQUE KEY `idroles_permisos_UNIQUE` (`idroles_permisos`),
  KEY `fgk_roles_roles_permisos_idx` (`idrol`),
  KEY `fgk_permisos_roles_permisos_idx` (`idpermiso`),
  CONSTRAINT `fgk_permisos_roles_permisos` FOREIGN KEY (`idpermiso`) REFERENCES `permisos` (`idpermiso`) ON UPDATE CASCADE,
  CONSTRAINT `fgk_roles_roles_permisos` FOREIGN KEY (`idrol`) REFERENCES `roles` (`idrol`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles_permisos`
--

LOCK TABLES `roles_permisos` WRITE;
/*!40000 ALTER TABLE `roles_permisos` DISABLE KEYS */;
/*!40000 ALTER TABLE `roles_permisos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subgrupos`
--

DROP TABLE IF EXISTS `subgrupos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subgrupos` (
  `idsubgrupo` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  `idgrupo` int NOT NULL,
  `idusuario` int NOT NULL,
  `fechacreacion` datetime NOT NULL,
  PRIMARY KEY (`idsubgrupo`),
  UNIQUE KEY `idsubgrupo_UNIQUE` (`idsubgrupo`),
  KEY `fgk_usuarios_subgrupos_idx` (`idusuario`),
  KEY `fgk_grupos_subgrupos_idx` (`idgrupo`),
  CONSTRAINT `fgk_grupos_subgrupos` FOREIGN KEY (`idgrupo`) REFERENCES `grupos` (`idgrupo`) ON UPDATE CASCADE,
  CONSTRAINT `fgk_usuarios_subgrupos` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subgrupos`
--

LOCK TABLES `subgrupos` WRITE;
/*!40000 ALTER TABLE `subgrupos` DISABLE KEYS */;
/*!40000 ALTER TABLE `subgrupos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sucursales`
--

DROP TABLE IF EXISTS `sucursales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sucursales` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(20) NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT '1',
  `fechacreacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sucursales`
--

LOCK TABLES `sucursales` WRITE;
/*!40000 ALTER TABLE `sucursales` DISABLE KEYS */;
INSERT INTO `sucursales` VALUES (2,'PRINCIPAL',1,'2020-11-30 21:49:20');
/*!40000 ALTER TABLE `sucursales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tarifasiva`
--

DROP TABLE IF EXISTS `tarifasiva`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tarifasiva` (
  `idtarifaiva` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(20) NOT NULL,
  `tarifa` int NOT NULL,
  `fechacreacion` datetime NOT NULL,
  `idusuario` int NOT NULL,
  PRIMARY KEY (`idtarifaiva`),
  UNIQUE KEY `idtarifaiva_UNIQUE` (`idtarifaiva`),
  UNIQUE KEY `nombre_UNIQUE` (`nombre`),
  KEY `fgk_usuario_tarifasiva_idx` (`idusuario`),
  CONSTRAINT `fgk_usuario_tarifasiva` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tarifasiva`
--

LOCK TABLES `tarifasiva` WRITE;
/*!40000 ALTER TABLE `tarifasiva` DISABLE KEYS */;
INSERT INTO `tarifasiva` VALUES (1,'GRABADOS 19%',19,'2020-07-19 06:17:26',1),(2,'GRABADOS 5%',5,'2020-07-19 06:17:26',1),(3,'EXENTOS',0,'2020-11-30 21:50:37',1);
/*!40000 ALTER TABLE `tarifasiva` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipos_documento`
--

DROP TABLE IF EXISTS `tipos_documento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipos_documento` (
  `idtipo_documento` int NOT NULL AUTO_INCREMENT,
  `prefijo` varchar(4) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `idusuario` int NOT NULL,
  `fechacreacion` datetime NOT NULL,
  PRIMARY KEY (`idtipo_documento`),
  UNIQUE KEY `idtipo_documento_UNIQUE` (`idtipo_documento`),
  UNIQUE KEY `prefijo_UNIQUE` (`prefijo`),
  KEY `fgk_usuarios_tipos_documento_idx` (`idusuario`),
  CONSTRAINT `fgk_usuarios_tipos_documento` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_documento`
--

LOCK TABLES `tipos_documento` WRITE;
/*!40000 ALTER TABLE `tipos_documento` DISABLE KEYS */;
INSERT INTO `tipos_documento` VALUES (1,'CC','CEDULA DE CIUDADANIA',1,'2020-07-19 06:05:02'),(2,'NIT','NUMERO DE IDENTIFICACION TRIBUTARIA',1,'2020-07-19 06:05:02');
/*!40000 ALTER TABLE `tipos_documento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipos_informe`
--

DROP TABLE IF EXISTS `tipos_informe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipos_informe` (
  `idtipo_informe` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  `modulo` varchar(45) NOT NULL,
  PRIMARY KEY (`idtipo_informe`),
  UNIQUE KEY `idtipo_informe_facturacion_UNIQUE` (`idtipo_informe`),
  UNIQUE KEY `nombre_UNIQUE` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_informe`
--

LOCK TABLES `tipos_informe` WRITE;
/*!40000 ALTER TABLE `tipos_informe` DISABLE KEYS */;
/*!40000 ALTER TABLE `tipos_informe` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `idusuario` int NOT NULL AUTO_INCREMENT,
  `usuario` varchar(8) NOT NULL,
  `password` varchar(12) NOT NULL,
  `idRol` int NOT NULL,
  `asignacion` varchar(50) NOT NULL,
  `fechacreacion` datetime NOT NULL,
  `idsucursal` int DEFAULT NULL,
  PRIMARY KEY (`idusuario`),
  UNIQUE KEY `idusuario_UNIQUE` (`idusuario`),
  UNIQUE KEY `usuario_UNIQUE` (`usuario`),
  KEY `fgk_roles_usuarios_idx` (`idRol`),
  KEY `fgk_sucurales_usuarios_idx` (`idsucursal`),
  CONSTRAINT `fgk_roles_usuarios` FOREIGN KEY (`idRol`) REFERENCES `roles` (`idrol`) ON UPDATE CASCADE,
  CONSTRAINT `fgk_sucurales_usuarios` FOREIGN KEY (`idsucursal`) REFERENCES `sucursales` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'ADMIN','1234',2,'ADMINISTRADOR DEL SISTEMA','2020-11-30 21:49:30',2);
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'soltec'
--

--
-- Dumping routines for database 'soltec'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-12-04  7:47:55
