 # Homework
 
/*
Con el objetivo de asegurarse de que la calidad de la información con la que se va a trabajar sea la óptima,
es necesario realizar una lista de propuestas de mejora teniendo en cuenta los siguientes puntos:

1) ¿Qué tan actualizada está la información? La forma en que se actualiza ó mantiene esa información, ¿se puede mejorar?
La información está desactualizada. Se puede mejorar utilizando un sistema que nos brinde actualizaciones con cierta periodicidad
2) ¿Los datos están completos en todas las tablas?
No, hay muchas tablas con datos faltantes.
3) ¿Se conocen las fuentes de los datos?
No, los datos provienen de una fuente desconocida.
4) Al integrar estos datos, ¿es prudente que haya una normalización respecto de nombrar las tablas y sus campos?
Si, para que se puedan integrar de manera más eficiente y con menos error.
5) Es importante revisar la consistencia de los datos:
¿Se pueden relacionar todas las tablas al modelo? Sí.
¿Cuáles son las tablas de hechos y las tablas dimensionales o maestros?
Maestros -> Calendario, Canal, Cliente, Empleado, Producto, Proveedor, Sucursal, Tipo_Gasto
Hechos -> Compra, Gasto, Venta
¿Podemos hacer esa separación en los datos que tenemos (tablas de hecho y dimensiones)? Sí.
¿Hay claves duplicadas? Sí, en la tabla empleado hay duplicados.
¿Cuáles son variables cualitativas y cuáles son cuantitativas? Precio y Cantidad son cuantitativas. Nombre y Direccion son cualitativas.
¿Qué acciones podemos aplicar sobre las mismas? Cuanti: Promedio. Cuali: Group by
*/
# Limpieza, Valores faltantes y Normalización

# 6) Normalizar los nombres de los campos y colocar el tipo de dato adecuado para cada uno en cada una de las tablas.
# Descartar columnas que consideres que no tienen relevancia.

/*Nombres de campos*/
ALTER TABLE Calendario CHANGE id IdFecha int not null;
ALTER TABLE Canal CHANGE CODIGO IdCanal int not null,
				  CHANGE DESCRIPCION Canal varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NOT NULL;
ALTER TABLE Cliente DROP COLUMN col10,
					CHANGE ID IdCliente int not null;
ALTER TABLE Empleado CHANGE ID_empleado IdEmpleado int not null;
ALTER TABLE PRODUCTO 	CHANGE ID_PRODUCTO IdProducto int not null,
						CHANGE concepto Producto varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NOT NULL,
						CHANGE precio Precio Decimal(12,2);
ALTER TABLE Proveedor 	CHANGE IDProveedor IdProveedor int not null,
						CHANGE Adress Domicilio varchar(35),
						CHANGE City Ciudad varchar(30),
						CHANGE State Provincia varchar(25),
						CHANGE Country Pais varchar(20),
						CHANGE departamen Localidad varchar(20);
ALTER TABLE Sucursal CHANGE ID IdSucursal int not null,
					 CHANGE Direccion Domicilio varchar(50);
ALTER TABLE tipo_gasto CHANGE Descripcion Tipo_Gasto varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NOT NULL;

/*Tipos de Datos*/
ALTER TABLE cliente	ADD Longitud DECIMAL(13,10) NOT NULL DEFAULT '0' AFTER Y,
					ADD Latitud DECIMAL(13,10) NOT NULL DEFAULT '0' AFTER Longitud;
UPDATE cliente SET Y = '0' WHERE Y = '';
UPDATE cliente SET X = '0' WHERE X = '';
UPDATE cliente SET Latitud = REPLACE(Y,',','.');
UPDATE cliente SET Longitud = REPLACE(X,',','.');
ALTER TABLE cliente DROP Y;
ALTER TABLE cliente DROP X;

ALTER TABLE sucursal	ADD Longitud2 DECIMAL(13,10) NOT NULL DEFAULT '0' AFTER Longitud,
						ADD Latitud2 DECIMAL(13,10) NOT NULL DEFAULT '0' AFTER Longitud2;
UPDATE sucursal SET Latitud2 = REPLACE(Latitud,',','.');
UPDATE sucursal SET Longitud2 = REPLACE(Longitud,',','.');
ALTER TABLE sucursal DROP Latitud,
					 CHANGE Latitud2 Latitud DECIMAL(13,10) NOT NULL DEFAULT '0';
ALTER TABLE sucursal DROP Longitud,
					 CHANGE Longitud2 Longitud DECIMAL(13,10) NOT NULL DEFAULT '0';	

# 7) Buscar valores faltantes y campos inconsistentes en las tablas sucursal, proveedor, empleado y cliente.
# De encontrarlos, deberás corregirlos o desestimarlos. Propone y realiza una acción correctiva sobre ese problema.

select count(*) from sucursal
where '' in (IdSucursal, Sucursal, Direccion, Localidad, Provincia, Latitud, Longitud);
select count(*) from proveedor
where '' in (IdProveedor, Nombre, Direccion, Ciudad, Provincia, Pais, Localidad);
UPDATE `proveedor` SET Nombre = 'Sin Dato' WHERE TRIM(Nombre) = "" OR ISNULL(Nombre);
UPDATE `proveedor` SET Domicilio = 'Sin Dato' WHERE TRIM(Domicilio) = "" OR ISNULL(Domicilio);
-- UPDATE `proveedor` SET Ciudad = 'Sin Dato' WHERE TRIM(Ciudad) = "" OR ISNULL(Ciudad);
-- UPDATE `proveedor` SET Provincia = 'Sin Dato' WHERE TRIM(Provincia) = "" OR ISNULL(Provincia);
UPDATE `proveedor` SET Pais = 'Sin Dato' WHERE TRIM(Pais) = "" OR ISNULL(Pais);
-- UPDATE `proveedor` SET Departamento = 'Sin Dato' WHERE TRIM(Departamento) = "" OR ISNULL(Departamento);
select count(*) from empleado
where '' in (IdEmpleado, Apellido, Nombre, Sucursal, Sector, Cargo, Salario);
select count(*) from cliente
where '' in (IdCliente, Provincia, Nombre_y_Apellido, Domicilio, Telefono, Edad, Localidad, Longitud, Latitud);
UPDATE `cliente` SET Domicilio = 'Sin Dato' WHERE TRIM(Domicilio) = "" OR ISNULL(Domicilio);
-- UPDATE `cliente` SET Localidad = 'Sin Dato' WHERE TRIM(Localidad) = "" OR ISNULL(Localidad);
UPDATE `cliente` SET Nombre_y_Apellido = 'Sin Dato' WHERE TRIM(Nombre_y_Apellido) = "" OR ISNULL(Nombre_y_Apellido);
-- UPDATE `cliente` SET Provincia = 'Sin Dato' WHERE TRIM(Provincia) = "" OR ISNULL(Provincia);

# 8) Chequear la consistencia de los campos precio y cantidad de la tabla de ventas.

UPDATE VENTA SET PRECIO = 0 WHERE PRECIO = '';
ALTER TABLE venta CHANGE Precio Precio decimal(15,3) not null default 0;
UPDATE Venta v JOIN producto p ON (v.IdProducto = p.IdProducto) 
SET v.Precio = p.Precio WHERE v.Precio = 0;

UPDATE venta SET Cantidad = REPLACE(Cantidad, '\r', '');
# Tabla auxiliar donde se guardarán registros con: 1-Cantidad en Cero
DROP TABLE IF EXISTS `aux_venta`;
CREATE TABLE IF NOT EXISTS `aux_venta` (
  `IdVenta`				int,
  `Fecha` 				DATE NOT NULL,
  `Fecha_Entrega` 		DATE NOT NULL,
  `IdCliente`			int, 
  `IdSucursal`			int,
  `IdEmpleado`			int,
  `IdProducto`			int,
  `Precio`				decimal (13,2),
  `Cantidad`			int,
  `Motivo`				int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
INSERT INTO aux_venta (IdVenta, Fecha, Fecha_Entrega, IdCliente, IdSucursal, IdEmpleado, IdProducto, Precio, Cantidad, Motivo)
SELECT IdVenta, Fecha, Fecha_Entrega, IdCliente, IdSucursal, IdEmpleado, IdProducto, Precio, 0, 1
FROM venta WHERE Cantidad = '' or Cantidad is null;

UPDATE VENTA SET Cantidad = 1 WHERE Cantidad = '';
ALTER TABLE venta CHANGE Cantidad Cantidad int not null default 0;

# 9) Utilizar la funcion provista 'UC_Words' para modificar a letra capital los campos que contengan descripciones para todas las tablas.

UPDATE cliente SET 	Provincia = UC_Words(TRIM(Provincia)),
					Localidad = UC_Words(TRIM(Localidad)),
                    Domicilio = UC_Words(TRIM(Domicilio)),
                    Nombre_y_Apellido = UC_Words(TRIM(Nombre_y_Apellido));
					
UPDATE sucursal SET Provincia = UC_Words(TRIM(Provincia)),
					Localidad = UC_Words(TRIM(Localidad)),
                    Domicilio = UC_Words(TRIM(Domicilio)),
                    Sucursal = UC_Words(TRIM(Sucursal));
					
UPDATE proveedor SET Provincia = UC_Words(TRIM(Provincia)),
					Ciudad = UC_Words(TRIM(Ciudad)),
                    Localidad = UC_Words(TRIM(Localidad)),
                    Pais = UC_Words(TRIM(Pais)),
                    Nombre = UC_Words(TRIM(Nombre)),
                    Domicilio = UC_Words(TRIM(Domicilio));

UPDATE producto SET Producto = UC_Words(TRIM(Producto)),
					Tipo = UC_Words(TRIM(Tipo));
					
UPDATE empleado SET Sucursal = UC_Words(TRIM(Sucursal)),
                    Sector = UC_Words(TRIM(Sector)),
                    Cargo = UC_Words(TRIM(Cargo)),
                    Nombre = UC_Words(TRIM(Nombre)),
                    Apellido = UC_Words(TRIM(Apellido));

# 10) Chequear que no haya claves duplicadas, y de encontrarla en alguna de las tablas, proponer una solución.

SELECT IdCliente, COUNT(*) FROM cliente GROUP BY IdCliente HAVING COUNT(*) > 1;
SELECT IdSucursal, COUNT(*) FROM sucursal GROUP BY IdSucursal HAVING COUNT(*) > 1;
SELECT IdEmpleado, COUNT(*) FROM empleado GROUP BY IdEmpleado HAVING COUNT(*) > 1;
SELECT IdProveedor, COUNT(*) FROM proveedor GROUP BY IdProveedor HAVING COUNT(*) > 1;
SELECT IdProducto, COUNT(*) FROM producto GROUP BY IdProducto HAVING COUNT(*) > 1;

select distinct Sucursal from empleado
where Sucursal NOT IN (select Sucursal from sucursal);
UPDATE empleado SET Sucursal = 'Mendoza1' WHERE Sucursal = 'Mendoza 1';
UPDATE empleado SET Sucursal = 'Mendoza2' WHERE Sucursal = 'Mendoza 2';
UPDATE empleado SET Sucursal = 'Córdoba Quiroz' WHERE Sucursal = 'Cordoba Quiroz';

ALTER TABLE `empleado` ADD `IdSucursal` INT NULL DEFAULT '0' AFTER `Sucursal`;
UPDATE empleado e JOIN sucursal s	ON (e.Sucursal = s.Sucursal)
SET e.IdSucursal = s.IdSucursal;
ALTER TABLE `empleado` DROP `Sucursal`;

ALTER TABLE `empleado` ADD `CodigoEmpleado` INT NULL DEFAULT '0' AFTER `IdEmpleado`;
UPDATE empleado SET CodigoEmpleado = IdEmpleado;
UPDATE empleado SET IdEmpleado = (IdSucursal * 1000000) + CodigoEmpleado;

/*Modificacion de la clave foranea de empleado en venta*/
UPDATE venta SET IdEmpleado = (IdSucursal * 1000000) + IdEmpleado;

# 11) Generar dos nuevas tablas a partir de la tabla 'empleado' que contengan las entidades Cargo y Sector.

DROP TABLE IF EXISTS `cargo`;
CREATE TABLE IF NOT EXISTS `cargo` (
  `IdCargo` int NOT NULL AUTO_INCREMENT,
  `Cargo` varchar(50) NOT NULL,
  PRIMARY KEY (`IdCargo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
INSERT INTO cargo (Cargo) SELECT DISTINCT Cargo FROM empleado ORDER BY 1;

DROP TABLE IF EXISTS `sector`;
CREATE TABLE IF NOT EXISTS `sector` (
  `IdSector` int NOT NULL AUTO_INCREMENT,
  `Sector` varchar(50) NOT NULL,
  PRIMARY KEY (`IdSector`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
INSERT INTO sector (Sector) SELECT DISTINCT Sector FROM empleado ORDER BY 1;

ALTER TABLE `empleado` 	ADD `IdSector` INT NOT NULL DEFAULT '0' AFTER `IdSucursal`, 
						ADD `IdCargo` INT NOT NULL DEFAULT '0' AFTER `IdSector`;

UPDATE empleado e JOIN cargo c ON (c.Cargo = e.Cargo) SET e.IdCargo = c.IdCargo;
UPDATE empleado e JOIN sector s ON (s.Sector = e.Sector) SET e.IdSector = s.IdSector;
ALTER TABLE `empleado` DROP `Cargo`;
ALTER TABLE `empleado` DROP `Sector`;

# 12) Generar una nueva tabla a partir de la tabla 'producto' que contenga la entidad Tipo de Producto.

ALTER TABLE `producto` ADD `IdTipoProducto` INT NOT NULL DEFAULT '0' AFTER `Precio`;

DROP TABLE IF EXISTS `tipo_producto`;
CREATE TABLE IF NOT EXISTS `tipo_producto` (
  `IdTipoProducto` int NOT NULL AUTO_INCREMENT,
  `TipoProducto` varchar(50) NOT NULL,
  PRIMARY KEY (`IdTipoProducto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO tipo_producto (TipoProducto) SELECT DISTINCT Tipo FROM producto ORDER BY 1;
UPDATE producto p JOIN tipo_producto t ON (p.Tipo = t.TipoProducto) SET p.IdTipoProducto = t.IdTipoProducto;
ALTER TABLE `producto` DROP `Tipo`;

# 13) Es necesario contar con una tabla de localidades del país con el fin de evaluar la apertura de una nueva sucursal y mejorar nuestros datos. 
# A partir de los datos en las tablas cliente, sucursal y proveedor hay que generar una tabla definitiva de Localidades y Provincias.
# Utilizando la nueva tabla de Localidades controlar y corregir (Normalizar) los campos Localidad y Provincia de las tablas cliente, sucursal y proveedor.

DROP TABLE IF EXISTS aux_Localidad;
CREATE TABLE IF NOT EXISTS aux_Localidad (
	Localidad_Original	VARCHAR(80),
	Provincia_Original	VARCHAR(50),
	Localidad_Normalizada	VARCHAR(80),
	Provincia_Normalizada	VARCHAR(50),
	IdLocalidad			INTEGER
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO aux_localidad (Localidad_Original, Provincia_Original, Localidad_Normalizada, Provincia_Normalizada, IdLocalidad)
SELECT DISTINCT Localidad, Provincia, Localidad, Provincia, 0 FROM cliente
UNION
SELECT DISTINCT Localidad, Provincia, Localidad, Provincia, 0 FROM sucursal
UNION
SELECT DISTINCT Ciudad, Provincia, Ciudad, Provincia, 0 FROM proveedor
ORDER BY 2, 1;

UPDATE `aux_localidad` SET Provincia_Normalizada = 'Buenos Aires'
WHERE Provincia_Original IN ('B. Aires',
                            'B.Aires',
                            'Bs As',
                            'Bs.As.',
                            'Buenos Aires',
                            'C Debuenos Aires',
                            'Caba',
                            'Ciudad De Buenos Aires',
                            'Pcia Bs As',
                            'Prov De Bs As.',
                            'Provincia De Buenos Aires');
							
UPDATE `aux_localidad` SET Localidad_Normalizada = 'Capital Federal'
WHERE Localidad_Original IN ('Boca De Atencion Monte Castro',
                            'Caba',
                            'Cap.   Federal',
                            'Cap. Fed.',
                            'Capfed',
                            'Capital',
                            'Capital Federal',
                            'Cdad De Buenos Aires',
                            'Ciudad De Buenos Aires')
AND Provincia_Normalizada = 'Buenos Aires';
							
UPDATE `aux_localidad` SET Localidad_Normalizada = 'Córdoba'
WHERE Localidad_Original IN ('Coroba',
                            'Cordoba',
							'Cã³rdoba')
AND Provincia_Normalizada = 'Córdoba';

SELECT DISTINCT Provincia_Normalizada FROM AUX_LOCALIDAD;

DROP TABLE IF EXISTS `provincia`;
CREATE TABLE IF NOT EXISTS `provincia` (
  `IdProvincia` int NOT NULL AUTO_INCREMENT,
  `Provincia` varchar(50) NOT NULL,
  PRIMARY KEY (`IdProvincia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO provincia (Provincia)
SELECT DISTINCT Provincia_Normalizada
FROM aux_localidad
ORDER BY Provincia_Normalizada;

DROP TABLE IF EXISTS `localidad`;
CREATE TABLE IF NOT EXISTS `localidad` (
  `IdLocalidad` int NOT NULL AUTO_INCREMENT,
  `Localidad` varchar(80) NOT NULL,
  `Provincia` varchar(80) NOT NULL,
  `IdProvincia` int NOT NULL,
  PRIMARY KEY (`IdLocalidad`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO Localidad (Localidad, Provincia, IdProvincia)
SELECT	DISTINCT Localidad_Normalizada, Provincia_Normalizada, 0
FROM aux_localidad
ORDER BY Provincia_Normalizada, Localidad_Normalizada;

UPDATE localidad l JOIN provincia p ON (l.Provincia = p.Provincia)
SET l.IdProvincia = p.IdProvincia;
ALTER TABLE Localidad DROP Provincia;

UPDATE aux_localidad a
JOIN localidad l ON (l.Localidad = a.Localidad_Normalizada)
JOIN provincia p ON (a.Provincia_Normalizada = p.Provincia)
SET a.IdLocalidad = l.IdLocalidad;

ALTER TABLE `cliente` ADD `IdLocalidad` INT NOT NULL DEFAULT '0' AFTER `Localidad`;
UPDATE cliente c JOIN aux_localidad a
	ON (c.Provincia = a.Provincia_Original AND c.Localidad = a.Localidad_Original)
SET c.IdLocalidad = a.IdLocalidad;
ALTER TABLE `cliente`
  DROP `Provincia`,
  DROP `Localidad`;

ALTER TABLE `proveedor` ADD `IdLocalidad` INT NOT NULL DEFAULT '0' AFTER Localidad;
UPDATE proveedor p JOIN aux_localidad a
	ON (p.Provincia = a.Provincia_Original AND p.Ciudad = a.Localidad_Original)
SET p.IdLocalidad = a.IdLocalidad;
ALTER TABLE `proveedor`
  DROP `Ciudad`,
  DROP `Provincia`,
  DROP `Pais`,
  DROP Localidad;

ALTER TABLE `sucursal` ADD `IdLocalidad` INT NOT NULL DEFAULT '0' AFTER `Provincia`;
UPDATE sucursal s JOIN aux_localidad a
	ON (s.Provincia = a.Provincia_Original AND s.Localidad = a.Localidad_Original)
SET s.IdLocalidad = a.IdLocalidad;
ALTER TABLE `sucursal`
  DROP `Localidad`,
  DROP `Provincia`;

# DROP TABLE AUX_LOCALIDAD;

# 14) Es necesario discretizar el campo edad en la tabla cliente.

ALTER TABLE `cliente` ADD `Rango_Etario` VARCHAR(20) NOT NULL DEFAULT '-' AFTER `Edad`;

UPDATE cliente SET Rango_Etario = '1_Hasta 30 años' WHERE Edad <= 30;
UPDATE cliente SET Rango_Etario = '2_Entre 31 y 40 años' WHERE Edad <= 40 AND Rango_Etario = '-';
UPDATE cliente SET Rango_Etario = '3_Entre 41 a 50 años' WHERE Edad <= 50 AND Rango_Etario = '-';
UPDATE cliente SET Rango_Etario = '4_Entre 51 a 60 años' WHERE Edad <= 60 AND Rango_Etario = '-';
UPDATE cliente SET Rango_Etario = '5_Mayor de 60 años' WHERE Edad > 60 AND Rango_Etario = '-';

select Rango_Etario, count(*)
from cliente
group by Rango_Etario
order by 1;