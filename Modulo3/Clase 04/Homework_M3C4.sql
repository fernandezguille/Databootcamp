## Homework

# 1. Genere 5 consultas simples con alguna función de agregación y filtrado sobre las tablas. Anote los resultados de la ficha de estadísticas.

SELECT IdProducto, count(*) FROM VENTA where IdProducto = 42767; #0:00:0.0272
SELECT IdSucursal, avg(Precio) FROM VENTA where IdSucursal = 15; #0:00:0.0374
SELECT IdSucursal, sum(Cantidad) FROM VENTA where IdSucursal = 10 and year(Fecha) = 2020; #0:00:0.0406
SELECT IdProducto, SUM(Precio) FROM VENTA group by IdProducto; #0:00:0.0754
SELECT IdSucursal, sum(Cantidad*Precio) FROM VENTA group by IdSucursal; #0:00:0.0996

# 2. A partir del conjunto de datos elaborado en clases anteriores, genere las PK de cada una de las tablas a partir del campo que cumpla con los requisitos correspondientes.

ALTER TABLE canal ADD PRIMARY KEY (IdCanal);
ALTER TABLE cliente ADD PRIMARY KEY (IdCliente);
ALTER TABLE compra ADD PRIMARY KEY (IdCompra);
ALTER TABLE empleado ADD PRIMARY KEY (IdEmpleado);
ALTER TABLE gasto ADD PRIMARY KEY (IdGasto);
ALTER TABLE producto ADD PRIMARY KEY (IdProducto);
ALTER TABLE proveedor ADD PRIMARY KEY (IdProveedor);
ALTER TABLE tipo_gasto ADD PRIMARY KEY (IdTipoGasto);
ALTER TABLE venta ADD PRIMARY KEY (IdVenta);

# 3. Genere la indexación de los campos que representen fechas o ID en las tablas:

CREATE INDEX Fecha ON calendario(fecha);
CREATE INDEX Fecha ON Venta(Fecha);
ALTER TABLE VENTA ADD INDEX (Fecha_entrega);
ALTER TABLE VENTA ADD INDEX (IdCanal);
ALTER TABLE VENTA ADD INDEX (IdCliente);
ALTER TABLE VENTA ADD INDEX (IdSucursal);
ALTER TABLE VENTA ADD INDEX (IdEmpleado);
ALTER TABLE VENTA ADD INDEX (IdProducto);
CREATE INDEX ID ON Canal(IdCanal);
CREATE INDEX ID ON producto(IdProducto);
ALTER TABLE PRODUCTO ADD INDEX (IdTipoProducto);
CREATE INDEX ID ON tipo_producto(IdTipoProducto);
CREATE INDEX ID ON sucursal(Idsucursal);
ALTER TABLE SUCURSAL ADD INDEX (IdLocalidad);
CREATE INDEX ID ON empleado(Idempleado);
ALTER TABLE empleado ADD INDEX(IdSucursal);
ALTER TABLE empleado ADD INDEX(IdSector);
ALTER TABLE empleado ADD INDEX(IdCargo);
CREATE INDEX ID ON localidad(Idlocalidad);
ALTER TABLE Localidad ADD INDEX (IdProvincia);
CREATE INDEX ID ON proveedor(Idproveedor);
ALTER TABLE PROVEEDOR ADD INDEX (IdLocalidad);
CREATE INDEX Fecha ON gasto(fecha);
ALTER TABLE gasto ADD INDEX (IdSucursal);
ALTER TABLE gasto ADD INDEX (IdTipoGasto);
CREATE INDEX ID ON cliente(Idcliente);
ALTER TABLE cliente ADD INDEX(IdLocalidad);
CREATE INDEX Fecha ON compra(fecha);
ALTER TABLE compra ADD INDEX(IdProducto);
ALTER TABLE compra ADD INDEX(IdProveedor);

ALTER TABLE VENTA ADD constraint venta_fk_fecha FOREIGN KEY (fecha) references CALENDARIO (FECHA) ON DELETE RESTRICT ON UPDATE restrict;
ALTER TABLE venta ADD CONSTRAINT `venta_fk_cliente` FOREIGN KEY (IdCliente) REFERENCES cliente (IdCliente) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE venta ADD CONSTRAINT `venta_fk_sucursal` FOREIGN KEY (IdSucursal) REFERENCES sucursal (IdSucursal) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE venta ADD CONSTRAINT `venta_fk_producto` FOREIGN KEY (IdProducto) REFERENCES producto (IdProducto) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE venta ADD CONSTRAINT `venta_fk_empleado` FOREIGN KEY (IdEmpleado) REFERENCES empleado (IdEmpleado) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE venta ADD CONSTRAINT `venta_fk_canal` FOREIGN KEY (IdCanal) REFERENCES canal (IdCanal) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE producto ADD CONSTRAINT `producto_fk_tipoproducto` FOREIGN KEY (IdTipoProducto) REFERENCES tipo_producto (IdTipoProducto) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE empleado ADD CONSTRAINT `empleado_fk_sector` FOREIGN KEY (IdSector) REFERENCES sector (IdSector) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE empleado ADD CONSTRAINT `empleado_fk_cargo` FOREIGN KEY (IdCargo) REFERENCES cargo (IdCargo) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE empleado ADD CONSTRAINT `empleado_fk_sucursal` FOREIGN KEY (IdSucursal) REFERENCES sucursal (IdSucursal) ON DELETE RESTRICT ON UPDATE RESTRICT;
-- no me anduvo
insert into Provincia VALUE (0, 'Sin datos');
insert into Localidad VALUE (586, 'Sin datos', 9);
Update cliente set idlocalidad = 586 where Idlocalidad = 0;
ALTER TABLE cliente ADD CONSTRAINT `cliente_fk_localidad` FOREIGN KEY (IdLocalidad) REFERENCES localidad (IdLocalidad) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE proveedor ADD CONSTRAINT `proveedor_fk_localidad` FOREIGN KEY (IdLocalidad) REFERENCES localidad (IdLocalidad) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE sucursal ADD CONSTRAINT `sucursal_fk_localidad` FOREIGN KEY (IdLocalidad) REFERENCES localidad (IdLocalidad) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE localidad ADD CONSTRAINT `localidad_fk_provincia` FOREIGN KEY (IdProvincia) REFERENCES provincia (IdProvincia) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE compra ADD CONSTRAINT `compra_fk_fecha` FOREIGN KEY (Fecha) REFERENCES calendario (fecha) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE compra ADD CONSTRAINT `compra_fk_producto` FOREIGN KEY (IdProducto) REFERENCES producto (IdProducto) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE compra ADD CONSTRAINT `compra_fk_proveedor` FOREIGN KEY (IdProveedor) REFERENCES proveedor (IdProveedor) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE gasto ADD CONSTRAINT `gasto_fk_fecha` FOREIGN KEY (Fecha) REFERENCES calendario (fecha) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE gasto ADD CONSTRAINT `gasto_fk_sucursal` FOREIGN KEY (IdSucursal) REFERENCES sucursal (IdSucursal) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE gasto ADD CONSTRAINT `gasto_fk_tipogasto` FOREIGN KEY (IdTipoGasto) REFERENCES tipo_gasto (IdTipoGasto) ON DELETE RESTRICT ON UPDATE RESTRICT;

# 4. Ahora que las tablas están indexadas, vuelva a ejecutar las consultas del punto 1 y evalue las estadístias. ¿Nota alguna diferencia?.

SELECT IdProducto, count(*) FROM VENTA where IdProducto = 42767; #0:00:0.0126 server
SELECT IdSucursal, avg(Precio) FROM VENTA where IdSucursal = 15; #0:00:0.0154 server
SELECT IdSucursal, sum(Cantidad) FROM VENTA where IdSucursal = 10 and year(Fecha) = 2020; #0:00:0.0230 server
SELECT IdProducto, SUM(Precio) FROM VENTA group by IdProducto; #0:00:0.0515 server
SELECT IdSucursal, sum(Cantidad*Precio) FROM VENTA group by IdSucursal; #0:00:0.0409 server

# 5. Genere una nueva tabla que lleve el nombre fact_venta (modelo estrella) que pueda agrupar los hechos relevantes de la tabla venta, los campos a considerar deben ser los siguientes:

DROP TABLE Fact_venta;
CREATE TABLE IF NOT EXISTS `fact_venta` (
  `IdVenta`				int,
  `Fecha` 				DATE NOT NULL,
  `Fecha_Entrega` 		DATE NOT NULL,
  `IdCanal`				int, 
  `IdCliente`			int, 
  `IdEmpleado`			int,
  `IdProducto`			int,
  `Precio`				DECIMAL(15,2),
  `Cantidad`			int
);

# 6. A partir de la tabla creada en el punto anterior, deberá poblarla con los datos de la tabla ventas.

ALTER TABLE `fact_venta` ADD PRIMARY KEY(`IdVenta`);
ALTER TABLE `fact_venta` ADD INDEX(`IdProducto`);
ALTER TABLE `fact_venta` ADD INDEX(`IdEmpleado`);
ALTER TABLE `fact_venta` ADD INDEX(`Fecha`);
ALTER TABLE `fact_venta` ADD INDEX(`Fecha_Entrega`);
ALTER TABLE `fact_venta` ADD INDEX(`IdCliente`);
ALTER TABLE `fact_venta` ADD INDEX(`IdCanal`);

INSERT INTO fact_venta
SELECT IdVenta, Fecha, Fecha_Entrega, IdCanal, IdCliente, IdEmpleado, IdProducto, Precio, Cantidad
FROM venta
WHERE YEAR(Fecha) = 2020;

DROP TABLE IF EXISTS dim_cliente;
CREATE TABLE IF NOT EXISTS dim_cliente (
	IdCliente			int,
	Nombre_y_Apellido	VARCHAR(80),
	Domicilio			VARCHAR(150),
	Telefono			VARCHAR(30),
	Rango_Etario		VARCHAR(20),
	IdLocalidad			int,
	Latitud				DECIMAL(13,10),
	Longitud			DECIMAL(13,10)
);
           
INSERT INTO dim_cliente
SELECT IdCliente, Nombre_y_Apellido, Domicilio, Telefono, Rango_Etario, IdLocalidad, Latitud, Longitud
FROM cliente
WHERE IdCliente IN (SELECT distinct IdCliente FROM fact_venta);

DROP TABLE IF EXISTS dim_producto;
CREATE TABLE IF NOT EXISTS dim_producto (
	IdProducto					int,
	Producto					VARCHAR(100),
	IdTipoProducto				VARCHAR(50)
);

INSERT INTO dim_producto
SELECT IdProducto, Producto, IdTipoProducto
FROM producto
WHERE IdProducto IN (SELECT distinct IdProducto FROM fact_venta);