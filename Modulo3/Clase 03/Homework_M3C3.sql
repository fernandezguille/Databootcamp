# Homework
# 1) Aplicar alguna técnica de detección de Outliers en la tabla ventas, sobre los campos Precio y Cantidad.

SELECT IdProducto, round(avg(Precio)) as Promedio, round(std(Precio),2) as STD
FROM Venta GROUP BY IdProducto;

# Detección de outliers
SELECT V.*, s.Promedio, S.STD FROM VENTA V JOIN (
SELECT IdProducto, round(avg(Precio),2) as Promedio, round(std(Precio),2) as STD
FROM Venta GROUP BY IdProducto) S
ON (V.IdProducto = S.IdProducto)
WHERE V.PRECIO < (S.Promedio - 3 * S.STD) OR V.PRECIO > (S.Promedio + 3 * S.STD);

SELECT V.*, s.Promedio, S.STD FROM VENTA V JOIN (
SELECT IdProducto, round(avg(Cantidad),2) as Promedio, round(std(Cantidad),2) as STD
FROM Venta GROUP BY IdProducto) S
ON (V.IdProducto = S.IdProducto)
WHERE V.Cantidad < (S.Promedio - 3 * S.STD) OR V.Cantidad > (S.Promedio + 3 * S.STD);

# Inserción en la tabla Aux_Venta
INSERT INTO aux_venta
SELECT v.IdVenta, v.Fecha, v.Fecha_Entrega, v.IdCliente, v.IdSucursal, 
v.IdEmpleado, v.IdProducto, v.Precio, v.Cantidad, 2
FROM Venta v
JOIN (SELECT IdProducto, round(avg(Cantidad),2) as Promedio, round(std(Cantidad),2) as STD
FROM Venta GROUP BY IdProducto) S
ON (V.IdProducto = S.IdProducto)
WHERE V.Cantidad < (S.Promedio - 3 * S.STD) OR V.Cantidad > (S.Promedio + 3 * S.STD);

INSERT INTO aux_venta
SELECT v.IdVenta, v.Fecha, v.Fecha_Entrega, v.IdCliente, v.IdSucursal, 
v.IdEmpleado, v.IdProducto, v.Precio, v.Cantidad, 3
FROM Venta v
JOIN (SELECT IdProducto, round(avg(Precio),2) as Promedio, round(std(Precio),2) as STD
FROM Venta GROUP BY IdProducto) S
ON (V.IdProducto = S.IdProducto)
WHERE V.PRECIO < (S.Promedio - 3 * S.STD) OR V.PRECIO > (S.Promedio + 3 * S.STD);

# Agrego 0 a los outliers en la tabla venta
ALTER TABLE Venta ADD Outlier tinyint not null default '1' after Cantidad;
UPDATE VENTA V
JOIN AUX_VENTA A
ON (V.IdVenta = a.IdVenta AND A.Motivo IN (2,3))
SET V.OUTLIER = 0;

# Realizar diversas consultas para verificar la importancia de haber detectado Outliers.
# Por ejemplo ventas por sucursal en un período teniendo en cuenta outliers y descartándolos.

-- SELECT Sucursal, SumaVentas, CantidadVentas, SumaVentasOutliers, CantidadVentasOutliers
-- FROM
SELECT 	s.Sucursal,
			SUM(v.Precio * v.Cantidad * v.Outlier) 	as 	SumaVentas,
			SUM(v.Outlier) 							as	CantidadVentas,
			SUM(v.Precio * v.Cantidad) 				as 	SumaVentasOutliers,
			COUNT(*) 								as	CantidadVentasOutliers,
            SUM(v.Precio * v.Cantidad - v.Precio * v.Cantidad * v.Outlier)	as  Diferencia
	FROM venta v JOIN sucursal s
		ON (v.IdSucursal = s.IdSucursal
			AND YEAR(v.Fecha) = 2019)
	GROUP BY s.Sucursal;

SELECT 	co.TipoProducto,
		co.PromedioVentaConOutliers,
        so.PromedioVentaSinOutliers
FROM
	(SELECT 	tp.TipoProducto,
			AVG(v.Precio * v.Cantidad) as PromedioVentaConOutliers
	FROM 	venta v JOIN producto p
		ON (v.IdProducto = p.IdProducto)
			JOIN tipo_producto tp
		ON (p.IdTipoProducto = tp.IdTipoProducto)
	GROUP BY tp.TipoProducto) co
JOIN
	(SELECT 	tp.TipoProducto,
			AVG(v.Precio * v.Cantidad) as PromedioVentaSinOutliers
	FROM 	venta v JOIN producto p
		ON (v.IdProducto = p.IdProducto and v.Outlier = 1)
			JOIN tipo_producto tp
		ON (p.IdTipoProducto = tp.IdTipoProducto)
	GROUP BY tp.TipoProducto) so
ON co.TipoProducto = so.TipoProducto;

# 2) Es necesario armar un proceso, mediante el cual podamos integrar todas las fuentes, aplicar las transformaciones o reglas de negocio 
# necesarias a los datos y generar el modelo final que va a ser consumido desde los reportes. Este proceso debe ser claro y autodocumentado.
# ¿Se puede armar un esquema, donde sea posible detectar con mayor facilidad futuros errores en los datos?

# Sí

# 3) Elaborar 3 KPIs del negocio. Tener en cuenta que deben ser métricas fácilmente graficables, por lo tanto debemos asegurarnos de contar
# con los datos adecuados. 
# ¿Necesito tener el claro las métricas que voy a utilizar? Sí, para saber qué datos necesito
# ¿La métrica necesaria debe tener algún filtro en especial? Sí, no se deben considerar outliers.
# La Meta que se definió ¿se calcula con la misma métrica? Con un KPI

SELECT 	venta.Producto, 
		venta.SumaVentas, 
        venta.CantidadVentas, 
        venta.SumaVentasOutliers,
        venta.CantidadVentasOutliers,
        compra.SumaCompras, 
        compra.CantidadCompras,
        ((venta.SumaVentas / compra.SumaCompras - 1) * 100) as margen
FROM
	(SELECT 	p.Producto,
			SUM(v.Precio * v.Cantidad * v.Outlier) 	as 	SumaVentas,
			SUM(v.Outlier) 							as	CantidadVentas,
			SUM(v.Precio * v.Cantidad) 				as 	SumaVentasOutliers,
			COUNT(*) 								as	CantidadVentasOutliers
	FROM venta v JOIN producto p
		ON (v.IdProducto = p.IdProducto
			AND YEAR(v.Fecha) = 2019)
	GROUP BY p.Producto) AS venta
JOIN
	(SELECT 	p.Producto,
			SUM(c.Precio * c.Cantidad) 				as SumaCompras,
			COUNT(*)								as CantidadCompras
	FROM compra c JOIN producto p
		ON (c.IdProducto = p.IdProducto
			AND YEAR(c.Fecha) = 2019)
	GROUP BY p.Producto) as compra
ON (venta.Producto = compra.Producto);