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

DELIMITER && 

CREATE DEFINER=`root`@`localhost` PROCEDURE `inicializar_database`(IN `valor` VARCHAR(1)) NOT DETERMINISTIC CONTAINS SQL SQL SECURITY DEFINER BEGIN
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
END &&
DELIMITER ;