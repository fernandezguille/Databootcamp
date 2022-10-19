## Homework

# 1. Obtener un listado del nombre y apellido de cada cliente que haya adquirido algun producto junto al id del producto y su respectivo precio.

SELECT c.Nombre_y_Apellido, p.IdProducto, v.Precio
from Cliente C
JOIN venta v ON (c.IdCliente = v.IdCliente)
JOIN producto p ON (p.IdProducto = v.IdProducto);

# 2. Obteber un listado de clientes con la cantidad de productos adquiridos, incluyendo aquellos que nunca compraron algún producto.

SELECT C.Nombre_y_Apellido, sum(v.cantidad) as Cant_prod_adq
from cliente c
LEFT JOIN VENTA V ON (c.IdCliente = v.IdCliente)
GROUP BY 1
ORDER BY 2 DESC;

# 3. Obtener un listado de cual fue el volumen de compra (cantidad) por año de cada cliente.

SELECT C.Nombre_y_Apellido, YEAR(V.FECHA), sum(v.cantidad) as Cant_prod_adq
FROM cliente C
JOIN venta V ON (c.IdCliente = v.IdCliente)
GROUP BY 1, 2
ORDER BY 1, 2;

# 4. Obtener un listado del nombre y apellido de cada cliente que haya adquirido algun producto junto al id del producto, la cantidad de productos adquiridos y el precio promedio.

SELECT c.Nombre_y_Apellido, p.IdProducto, SUM(v.Cantidad) AS Total, round(avg(v.Precio),2) as Precio_prom
from Cliente C
JOIN venta v ON (c.IdCliente = v.IdCliente)
JOIN producto p ON (p.IdProducto = v.IdProducto)
GROUP BY 1, 2
ORDER BY 1, 3 DESC;

# 5. Calcular la cantidad de productos vendidos y la suma total de ventas para cada localidad, presentar el análisis en un listado con el nombre de cada localidad.

SELECT L.Localidad, SUM(V.Cantidad) as Unidades_vendidas, sum(v.cantidad * v.Precio) as Total_venta
FROM LOCALIDAD L
JOIN cliente c ON (l.IdLocalidad = c.IdLocalidad)
JOIN venta v ON (c.IdCliente = v.IdCliente)
group by 1
order by 3 desc;
-- opcion sucursal
SELECT L.Localidad, SUM(V.Cantidad) as Unidades_vendidas, sum(v.cantidad * v.Precio) as Total_venta
FROM LOCALIDAD L
JOIN sucursal s ON (l.IdLocalidad = s.IdLocalidad)
JOIN venta v ON (s.IdSucursal = v.IdSucursal)
group by 1
order by 3 desc;

# 6. Cacular la cantidad de productos vendidos y la suma total de ventas para cada provincia, presentar el análisis en un listado con el nombre
# de cada provincia, pero solo en aquellas donde la suma total de las ventas fue superior a $100.000.

SELECT P.provincia, SUM(V.Cantidad) as Unidades_vendidas, sum(v.cantidad * v.Precio) as Total_venta
FROM Provincia P
join localidad L ON (p.IdProvincia = L.IdProvincia)
JOIN sucursal s ON (l.IdLocalidad = s.IdLocalidad)
JOIN venta v ON (s.IdSucursal = v.IdSucursal)
group by 1
HAVING Total_venta > 100000
order by 3 desc;

# 7. Obtener un listado de dos campos en donde por un lado se obtenga la cantidad de productos vendidos por rango etario
#  y las ventas totales en base a esta misma dimensión. El resultado debe obtenerse en un solo listado.

SELECT c.rango_etario, SUM(V.Cantidad) as Unidades_vendidas, sum(v.cantidad * v.Precio) as Total_venta
FROM VENTA v
JOIN CLIENTE C ON (C.IdCliente = V.Idcliente)
group by 1
order by 3 desc;

# 8. Obtener la cantidad de clientes por provincia.

SELECT P.PROVINCIA, COUNT(C.idcliente) as Cant_clientes
from provincia p
join localidad L ON (p.IdProvincia = L.IdProvincia)
JOIN cliente c ON (l.IdLocalidad = c.IdLocalidad)
group by 1
order by 2 desc;
