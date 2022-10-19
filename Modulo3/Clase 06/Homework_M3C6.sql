## Homework

# 1. Crear un procedimiento que recibe como parametro una fecha y muestre el listado de productos que se vendieron en esa fecha.

DROP PROCEDURE Ventas_por_fecha;
DELIMITER $$
CREATE PROCEDURE Ventas_por_fecha(Fecha DATE)
BEGIN
	SELECT P.Producto, count(P.Producto) AS Cantidad
	FROM producto p
	INNER JOIN venta v
	ON p.IdProducto = V.IdProducto
	WHERE v.Fecha = Fecha
    GROUP BY 1 ORDER BY 2 DESC;
END$$

DELIMITER ;

CALL Ventas_por_fecha('2020-05-30');

# 2. Crear una función que calcule el valor nominal de un margen bruto determinado por el usuario a partir del precio de lista de los productos.

DROP FUNCTION valor_nominal;
SET GLOBAL log_bin_trust_function_creators = 1;
DELIMITER $$
CREATE FUNCTION valor_nominal(margen_bruto DECIMAL(3,2), precio DECIMAL(15,2)) RETURNS DECIMAL(15,2)
BEGIN
    DECLARE valorNominal DECIMAL(15,2);
    SET valorNominal = precio*(1-margen_bruto);
    RETURN valorNominal;
END$$
DELIMITER ;

# 3. Obtener un listado de productos de IMPRESION y utilizarlo para cálcular el valor nominal de un margen bruto del 20% de cada uno de los productos.

SELECT p.producto, valor_nominal(0.20, p.precio)
from producto p
join tipo_producto t ON (t.IdTipoProducto = p.IdTipoProducto)
WHERE TipoProducto = 'Impresión';

# 4. Crear un procedimiento que permita listar los productos vendidos desde fact_venta a partir de un "Tipo" que determine el usuario.

DROP PROCEDURE Ventas_por_tipo;
DELIMITER $$
CREATE PROCEDURE Ventas_por_tipo(Tipo varchar(50))
BEGIN
	SELECT DISTINCT p.Producto, tp.TipoProducto, count(P.Producto) AS Cantidad
	FROM producto p
    INNER JOIN tipo_producto tp ON (tp.IdTipoProducto = p.IdTipoProducto)
    INNER JOIN fact_venta fv ON (p.IdProducto = fv.IdProducto)
	WHERE tp.TipoProducto LIKE concat('%',Tipo,'%')
    group by 1 ORDER BY 3 desc;
END$$

DELIMITER ;

CALL Ventas_por_tipo('Gabine');

# 5. Crear un procedimiento que permita realizar la inserción de datos en la tabla fact_venta.

DROP PROCEDURE Insertar_fact_venta;
DELIMITER $$
CREATE PROCEDURE Insertar_fact_venta(Fecha_ingresada DATE)
BEGIN
	INSERT INTO fact_venta
	SELECT IdVenta, Fecha, Fecha_Entrega, IdCanal, IdCliente, IdEmpleado, IdProducto, Precio, Cantidad
	FROM venta
	WHERE Fecha = Fecha_ingresada;
END$$

DELIMITER ;

CALL Insertar_fact_venta('2018-05-30');

# 6. Crear un procedimiento almacenado que reciba un grupo etario y devuelta el total de ventas para ese grupo.

DROP PROCEDURE Ventas_por_g_etario;
DELIMITER $$
CREATE PROCEDURE Ventas_por_g_etario(Grupo varchar(50))
BEGIN
	SELECT c.Rango_Etario, SUM(v.Precio * v.Cantidad) as Total_Ventas
	FROM cliente c
    JOIN VENTA V ON (v.IdCliente = c.IdCliente)
    WHERE c.Rango_Etario LIKE concat(Grupo,'%')
    GROUP BY 1;
END$$

DELIMITER ;

-- opción 2
DELIMITER $$
CREATE PROCEDURE Ventas_por_g_etario2(vmin int, vmax int)
BEGIN
	SELECT concat('Rango: ',vmin,'-',vmax), SUM(v.Precio * v.Cantidad) as Total_Ventas
	FROM VENTA V
    JOIN cliente c ON (v.IdCliente = c.IdCliente)
    where c.Edad BETWEEN vmin and vmax
    GROUP BY 1;
END$$

DELIMITER ;

CALL Ventas_por_g_etario('50');
CALL Ventas_por_g_etario2(33,44);

# 7. Crear una variable que se pase como valor para realizar una filtro sobre Rango_etario en una consulta génerica a dim_cliente.

SET @Filtro = '5_Mayor de 60 años';
SELECT *
FROM dim_cliente
WHERE Rango_Etario = @Filtro;