/*2020/10/30 agregado para realizar sucursales,bodegas y entradas de inventario*/
CREATE TABLE `soltec`.`sucursales` (
    `id` INT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(20) NULL,
    `estado` TINYINT(1) NULL DEFAULT '1',
    `idusuario` INT NULL,
    `fechacreacion` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE (`nombre`)
) ENGINE = InnoDB;

ALTER TABLE
    `sucursales`
ADD
    CONSTRAINT `fgk_usuarios_sucursales` FOREIGN KEY (`idusuario`) REFERENCES `usuarios`(`idusuario`) ON DELETE RESTRICT ON UPDATE CASCADE;

CREATE TABLE `soltec`.`bodegas` (
    `id` INT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(20) NULL,
    `estado` TINYINT(1) NULL DEFAULT '1',
    `idsucursal` INT NULL,
    `principal` TINYINT(1) NULL DEFAULT '0',
    `idusuario` INT NULL,
    `fechacreacion` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE (`nombre`)
) ENGINE = InnoDB;

ALTER TABLE
    `bodegas`
ADD
    CONSTRAINT `fgk_sucursales_bodegas` FOREIGN KEY (`idsucursal`) REFERENCES `sucursales`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE
    `bodegas`
ADD
    CONSTRAINT `fgk_usuarios_bodegas` FOREIGN KEY (`idusuario`) REFERENCES `usuarios`(`idusuario`) ON DELETE RESTRICT ON UPDATE CASCADE;

DROP PROCEDURE `inicializar_database`;

DELIMITER & & CREATE DEFINER = `root` @`localhost` PROCEDURE `inicializar_database`(IN `valor` VARCHAR(1)) NOT DETERMINISTIC CONTAINS SQL SQL SECURITY DEFINER BEGIN IF VALOR = 'T' THEN
DELETE FROM
    inventario;

ALTER TABLE
    inventario AUTO_INCREMENT = 1;

DELETE FROM
    movimiento_articulos;

ALTER TABLE
    movimiento_articulos AUTO_INCREMENT = 1;

DELETE FROM
    factura_compra_detalles;

ALTER TABLE
    factura_compra_detalles AUTO_INCREMENT = 1;

DELETE FROM
    factura_venta_detalles;

ALTER TABLE
    factura_venta_detalles AUTO_INCREMENT = 1;

DELETE FROM
    orden_compra_detalles;

ALTER TABLE
    orden_compra_detalles AUTO_INCREMENT = 1;

DELETE FROM
    facturas_compra;

ALTER TABLE
    facturas_compra AUTO_INCREMENT = 1;

DELETE FROM
    facturas_venta;

ALTER TABLE
    facturas_venta AUTO_INCREMENT = 1;

DELETE FROM
    ordenes_compra;

ALTER TABLE
    ordenes_compra AUTO_INCREMENT = 1;

DELETE FROM
    precios;

ALTER TABLE
    precios AUTO_INCREMENT = 1;

DELETE FROM
    articulos;

ALTER TABLE
    articulos AUTO_INCREMENT = 1;

DELETE FROM
    subgrupos;

ALTER TABLE
    subgrupos AUTO_INCREMENT = 1;

DELETE FROM
    grupos;

ALTER TABLE
    grupos AUTO_INCREMENT = 1;

DELETE FROM
    marcas;

ALTER TABLE
    marcas AUTO_INCREMENT = 1;

DELETE FROM
    clientes;

ALTER TABLE
    clientes AUTO_INCREMENT = 1;

DELETE FROM
    listasprecios;

ALTER TABLE
    listasprecios AUTO_INCREMENT = 1;

DELETE FROM
    numeracion;

ALTER TABLE
    numeracion AUTO_INCREMENT = 1;

DELETE FROM
    proveedores;

ALTER TABLE
    proveedores AUTO_INCREMENT = 1;

DELETE FROM
    regimenes;

ALTER TABLE
    regimenes AUTO_INCREMENT = 1;

DELETE FROM
    roles_permisos
WHERE
    idrol != 1;

DELETE FROM
    tarifasiva;

ALTER TABLE
    tarifasiva AUTO_INCREMENT = 1;

DELETE FROM
    tipos_documento;

ALTER TABLE
    tipos_documento AUTO_INCREMENT = 1;

DELETE FROM
    usuarios
WHERE
    idusuario != 1;

ALTER TABLE
    usuarios AUTO_INCREMENT = 2;

END IF;

IF VALOR = 'P' THEN
DELETE FROM
    inventario;

ALTER TABLE
    inventario AUTO_INCREMENT = 1;

DELETE FROM
    movimiento_articulos;

ALTER TABLE
    movimiento_articulos AUTO_INCREMENT = 1;

DELETE FROM
    factura_compra_detalles;

ALTER TABLE
    factura_compra_detalles AUTO_INCREMENT = 1;

DELETE FROM
    factura_venta_detalles;

ALTER TABLE
    factura_venta_detalles AUTO_INCREMENT = 1;

DELETE FROM
    orden_compra_detalles;

ALTER TABLE
    orden_compra_detalles AUTO_INCREMENT = 1;

DELETE FROM
    facturas_compra;

ALTER TABLE
    facturas_compra AUTO_INCREMENT = 1;

DELETE FROM
    facturas_venta;

ALTER TABLE
    facturas_venta AUTO_INCREMENT = 1;

DELETE FROM
    ordenes_compra;

ALTER TABLE
    ordenes_compra AUTO_INCREMENT = 1;

DELETE FROM
    devoluciones_ventas;

ALTER TABLE
    devoluciones_ventas AUTO_INCREMENT = 1;

DELETE FROM
    sucursales;

ALTER TABLE
    sucursales AUTO_INCREMENT = 1;

DELETE FROM
    bodegas;

ALTER TABLE
    bodegas AUTO_INCREMENT = 1;

END IF;

END & & DELIMITER;

/*Agregados para el manejo de inventario por bodegas 2020-11-12*/
ALTER TABLE
    `factura_venta_detalles`
ADD
    `idbodega` INT NOT NULL
AFTER
    `idfactura_venta`;

ALTER TABLE
    `factura_venta_detalles`
ADD
    CONSTRAINT `fgk_bodegas_factura_venta` FOREIGN KEY (`idbodega`) REFERENCES `bodegas`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE
    `movimiento_articulos`
ADD
    `idbodega` INT NOT NULL
AFTER
    `fechacreacion`;

ALTER TABLE
    `movimiento_articulos`
ADD
    CONSTRAINT `fgk_bodegas_movimiento_articulos` FOREIGN KEY (`idbodega`) REFERENCES `bodegas`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE
    `inventario`
ADD
    `idbodega` INT NOT NULL
AFTER
    `ultimocosto`;

ALTER TABLE
    `inventario`
ADD
    CONSTRAINT `fgk_bodegas_inventario` FOREIGN KEY (`idbodega`) REFERENCES `bodegas`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

DROP TRIGGER IF EXISTS `mov_inventario_ventas`;

DELIMITER & & CREATE DEFINER = `root` @`localhost` TRIGGER `mov_inventario_ventas`
AFTER
INSERT
    ON `factura_venta_detalles` FOR EACH ROW BEGIN
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
    tipomovimiento = 'S',
    cantidad = NEW.cantidadarticulo,
    fechacreacion = NOW(),
    idbodega = NEW.idbodega;

IF @ID > 0 THEN
UPDATE
    inventario
SET
    cantidad = cantidad - NEW.cantidadarticulo
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
        - NEW.cantidadarticulo,
        0,
        0,
        NEW.idbodega
    );

END IF;

END & & DELIMITER;

ALTER TABLE
    `devoluciones_ventas`
ADD
    `idbodega` INT NOT NULL
AFTER
    `fechacreacion`;

ALTER TABLE
    `devoluciones_ventas`
ADD
    CONSTRAINT `fgk_bodegas_devoluciones_ventas` FOREIGN KEY (`idbodega`) REFERENCES `bodegas`(`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

DROP TRIGGER IF EXISTS `ajuste_inventarios`;

DELIMITER & & CREATE DEFINER = `root` @`localhost` TRIGGER `ajuste_inventarios`
AFTER
INSERT
    ON `devoluciones_ventas` FOR EACH ROW BEGIN
SET
    @IDFACTURA = (
        SELECT
            idfactura_venta
        FROM
            factura_venta_detalles
        WHERE
            idfactura_venta_detalle = NEW.idfactura_venta_detalle
    );

SET
    @CODIGO = (
        SELECT
            codigoarticulo
        FROM
            factura_venta_detalles
        WHERE
            idfactura_venta_detalle = NEW.idfactura_venta_detalle
    );

SET
    @IDARTICULO = (
        SELECT
            idarticulo
        FROM
            articulos
        WHERE
            codigo = @CODIGO
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

SET
    @CANTIDAD = (
        SELECT
            cantidadarticulo
        FROM
            factura_venta_detalles
        WHERE
            idfactura_venta_detalle = NEW.idfactura_venta_detalle
    );

UPDATE
    facturas_venta
SET
    iddevolucion_ventas = NEW.iddevolucion_ventas
WHERE
    idfactura_venta = @IDFACTURA;

INSERT INTO
    movimiento_articulos
SET
    idarticulo = @IDARTICULO,
    tipomovimiento = 'E',
    cantidad = @CANTIDAD,
    fechacreacion = NOW(),
    idbodega = NEW.idbodega;

UPDATE
    inventario
SET
    cantidad = cantidad + @CANTIDAD
WHERE
    idinventario = @ID;

END & & DELIMITER;

CREATE TABLE `soltec`.`entradas` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `idusuario` INT NOT NULL,
    `fechacreacion` DATETIME NOT NULL,
    `estado` TINYINT(1) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB;

ALTER TABLE
    `entradas`
ADD
    CONSTRAINT `fgk_usuarios_entradas` FOREIGN KEY (`idusuario`) REFERENCES `usuarios`(`idusuario`) ON DELETE RESTRICT ON UPDATE CASCADE;

CREATE TABLE `soltec`.`entradas_detalle` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `identrada` INT NOT NULL,
    `codigoarticulo` VARCHAR(20) NOT NULL,
    `descripcionarticulo` VARCHAR(150) NOT NULL,
    `cantidadarticulo` DOUBLE NOT NULL,
    `valorarticulo` DOUBLE NOT NULL,
    `ivaarticulo` DOUBLE NOT NULL,
    `idtarifaiva` INT NOT NULL,
    `idbodega` INT NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB;

ALTER TABLE
    `entradas_detalle`
ADD
    CONSTRAINT `fgk_bodegas_entradas_detalle` FOREIGN KEY (`idbodega`) REFERENCES `bodegas`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE
    `entradas_detalle`
ADD
    CONSTRAINT `fgk_entradas_entradas_detalle` FOREIGN KEY (`identrada`) REFERENCES `entradas`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE
    `entradas_detalle`
ADD
    CONSTRAINT `fgk_tarifaiva_entradas_detalle` FOREIGN KEY (`idtarifaiva`) REFERENCES `tarifasiva`(`idtarifaiva`) ON DELETE RESTRICT ON UPDATE CASCADE;

DELIMITER & & CREATE DEFINER = `root` @`localhost` TRIGGER `inventario_entrada` BEFORE
INSERT
    ON `entradas_detalle` FOR EACH ROW BEGIN
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
END & & DELIMITER;