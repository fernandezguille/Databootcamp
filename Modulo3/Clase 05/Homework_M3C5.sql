## Homework

# 1. Crear una tabla que permita realizar el seguimiento de los usuarios que ingresan nuevos registros en fact_venta.

drop table audit_insert_venta;
CREATE TABLE IF NOT EXISTS audit_insert_venta(
	IdAuditoria INT NOT NULL AUTO_INCREMENT,
    `IdVenta`				int,
	`Fecha` 				DATE NOT NULL,
	`Fecha_Entrega` 		DATE NOT NULL,
	`IdCanal`				int, 
	`IdCliente`				int, 
	`IdEmpleado`			int,
	`IdProducto`			int,
	Fecha_Modificacion DATETIME not null,
    Usuario VARCHAR(50) NOT NULL,
    PRIMARY KEY(IdAuditoria)
);

DROP TRIGGER insert_venta;
CREATE TRIGGER insert_venta AFTER INSERT ON fact_venta
FOR EACH ROW
INSERT INTO audit_insert_venta
VALUES (null, NEW.IdVenta, NEW.Fecha, NEW.Fecha_Entrega, NEW.IdCanal, NEW.IdCliente, NEW.IdEmpleado, NEW.IdProducto, NOW(), current_user());

# 2. Crear una acción que permita la carga de datos en la tabla anterior.

truncate table fact_venta;
INSERT INTO fact_venta
SELECT IdVenta, Fecha, Fecha_Entrega, IdCanal, IdCliente, IdEmpleado, IdProducto, Precio, Cantidad
FROM venta
LIMIT 10;

# 3. Crear una tabla que permita registrar la cantidad total de registros, luego de cada ingreso a la tabla fact_venta.

DROP TABLE total_venta;
CREATE TABLE IF NOT EXISTS total_venta (
	IdTotal INT NOT NULL AUTO_INCREMENT,
    Total_registros int NOT NULL,
    Fecha_Modificacion DATETIME not null,
    Usuario VARCHAR(50) NOT NULL,
    PRIMARY KEY(IdTotal)
);

drop TRIGGER añadir_venta; 
CREATE TRIGGER añadir_venta AFTER INSERT ON fact_venta
FOR EACH ROW
INSERT INTO total_venta 
VALUES (null, (SELECT count(*) from fact_venta), now(), current_user());

# 4. Crear una acción que permita la carga de datos en la tabla anterior.

INSERT INTO fact_venta
SELECT IdVenta, Fecha, Fecha_Entrega, IdCanal, IdCliente, IdEmpleado, IdProducto, Precio, Cantidad
FROM venta
LIMIT 10, 10;

# 5. Crear una tabla que agrupe los datos de la tabla del item 3, a su vez crear un proceso de carga de los datos agrupados.

DROP TABLE registros_tablas;
CREATE TABLE IF NOT EXISTS registros_tablas (
	IdRegistrosTablas	int not null AUTO_INCREMENT,
	tabla				varchar(30),
    fecha				datetime,
    cantidad_Registros	int,
    PRIMARY KEY (IdRegistrosTablas)
    );

INSERT INTO registros_tablas
SELECT null, 'Gasto', now(), count(*)
from Gasto;
INSERT INTO registros_tablas
SELECT null, 'Venta', now(), count(*)
from Venta;

# 6. Crear una tabla que permita realizar el seguimiento de la actualización de registros de la tabla fact_venta.

drop table audit_update_venta;
CREATE TABLE IF NOT EXISTS audit_update_venta(
	IdVenta_cambios			int not null auto_increment,
	`Fecha` 				DATE NOT NULL,
	`Fecha_Entrega` 		DATE NOT NULL,
	`IdCanal`				int, 
	`IdCliente`				int, 
	`IdEmpleado`			int,
	`IdProducto`			int,
	`Precio`				DECIMAL(15,2),
	`Cantidad`				int,
    Fecha_Modificacion DATETIME not null,
    Usuario VARCHAR(50) NOT NULL,
    PRIMARY KEY(IdVenta_cambios)
);

DROP TRIGGER update_venta;
CREATE TRIGGER update_venta AFTER UPDATE ON fact_venta
FOR EACH ROW
INSERT INTO audit_update_venta 
VALUES (null, OLD.Fecha, OLD.Fecha_Entrega, OLD.IdCanal, OLD.IdCliente, OLD.IdEmpleado, OLD.IdProducto, OLD.Precio, OLD.Cantidad, now(), current_user());

# 7. Crear una acción que permitan realizar la carga de datos en la tabla anterior, para su actualización.

UPDATE fact_venta
SET Precio = 650 
WHERE IdVenta = 2;