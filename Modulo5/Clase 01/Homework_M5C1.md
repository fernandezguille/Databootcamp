## Homework

1. Desde la gerencia de ventas nos comentan que es necesario aumentar el volumen de facturación y cobertura de regiones ( tener clientes en la mayor cantidad posible de zonas) como también evitar la pérdida de clientes, hoy por hoy se manejan con un Excel que alguien armo en algún momento, pero no confían en esa data para seguir este nuevo objetivo, de manera tal que no se conoce realmente el estado de situación actual. Por lo tanto como departamento de data analytics tenemos que presentarles una propuesta basadas en datos para acompañar este proceso de negocio.  
En base al modelo de datos utilizado en M3  generar una un propuesta analítico de cada tipo según lo visto en clase:  

- a) Descriptivo  
- b) Dashboard  
- c) Predictivo  
- d) Prescriptivo

A. Volumen de facturación
a) Descriptivo 
	- Volumen de facturacion ACTUAL
b) Dashboard
	- idem descriptivo en automatizacion en el tiempo
c) Predictivo:
	- Donde hay menos facturacion? 
    - Existen tendencias?
	- Cual es la tendencia a la baja de facturación?  
d)Prescriptivo:
    - "Aumentar volumen de facturacion"
	- Simulacion de promociones (X % gratis sobre compras mayores a XX) 
	- Reduccion de perdidas o gastos
	- Optimizacion de stock y compras

B. Cobertura de regiones (tener clientes en la mayor cantidad posible de zonas)

a) Descriptivo 
	-Que hay que hacer? Analizar facturacion por zonas
	-Cobertura Regiones: Mostrar donde tenemos y donde no, geográficamente 
b) Dashboard
	- idem descriptivo en automatizacion en el tiempo
c) Predictivo:
	- Se existe estacionalidad por zonas?
d)Prescriptivo:
	- Ampliacion de zonas de venta on line
	- Implimentacion de sucursales o centros de distribución en zonas con tendecias 

C. Evitar la pérdida de clientes
a) Descriptivo 
 	- Cuanto clientes, cuantos nuevos y viejos?

b) Dashboard
	- idem descriptivo en automatizacion en el tiempo

c) Predictivo:
	- Que tipo de clientes nos dejan? Futuras bajas
	- Cual es la agencia con mas perdidas de clientes?
	- Probabilidad más alta o baja de que nos deje* 
*frecuentista

d)Prescriptivo:
	- Metodos de consolidación de clientes 
	- fomentar el aumento de compra on line o telefónica 
       (reducción de gastos porque la sucursal es más cara de mantener que el depósito)

2. Se decide presentar el volumen de ventas de 5 productos correspondientes a una distribuidora de alimentos. Los productos van de A = 100 un., B = 95 un., C =90 un., D = 88 un., E = 105 un.

 - a) ¿Que gráfico utilizaría?. Sería conveniente utilizar un gráfico de barras.  
 - b) ¿Sería correcto utilizar un gráfico de lineas? ¿Por qué?. Los gráficos de línea son recomanedables para representaciones evolutivas y series de tiempo.  
 - c) ¿Sería correcto utilizar un gráfico circular? ¿Por qué?. Los gráficos circulares no son recomendables para más de 3 variables o cuando la diferencia en las magnitudes de cada categoria no es muy notoria. 

3. Se presenta el siguiente gráfico.
![Ejercicio3](../_src/assets/ejer3.PNG)
 - a) ¿Es correcta su utilización? No es correcta la elección del gráfico, se dificulta el reconocimiento de patrones.
 - b) ¿Que inconveniente presenta a la hora de reconocer patrones? Se dificulta reconocer las magnitudes de las categorías a simple vista.
 - c) ¿Qué otros tipos de gráficos utilizaría? Se podría utilizar un gráfico de barras ordenado por calificación.
 - d) ¿Que tipo de tematicas estarían relacionadas a la variable presentada? Podría relacionarse la satisfacción del cliente en general.

4. Debes instalar Power BI Desktop y seguir las instrucciones del siguiente link para realizar tu primer conexión de datos:

[Conexión OData](https://docs.microsoft.com/en-us/power-query/power-query-ui)

- Conecta las tablas "Products", "Orders", "Order_Details".

5. Investigar que es un mockup y diseñar uno para el modelo presentado, realice la selección de gráficos de cada métrica conforme a las reglas presentadas en esta clase.  
Las métricas a representar son:
  - Filtros para Fecha de orden, País, Ciudad y Producto.
  - Cantidad de ventas totales (Agregar una columna cálculada Total = Order_Details[Quantity]*Order_Details[UnitPrice]).  
  [Columnas cálculadas](https://docs.microsoft.com/es-es/power-bi/transform-model/desktop-tutorial-create-calculated-columns).
  - Ventas por ciudad.
  - Ventas por productos.
  - Evolución del total de ventas por fecha de orden.
  - Top 10 de ventas por productos.

6. Relaciona cada situación con algún tipo de gráfico:
- a) Velocidad de frenado promedio de 5 modelos distintos de vehículos.<br>
Gráfico de columnas:<br>
Eje x = modelos de vehículos.<br>
Eje y = Velocidad promedio de frenado.<br>
- b) Costo de una llamada por segundos.<br>
Gráfico de líneas:
Eje x = Costo de la llamada.<br>
Eje y = Segundos de duración.<br>
- c) El recorrido del equipo de ventas de una distribuidora con 4 paradas y las sumas vendidas en cada una.<br>
Mapa georeferenciado:<br>
Latiud y longitud de cada parada.<br>
Importe de ventas totales en cada punto.<br>
- d) Cantidad de edificios y casas que conforman un barrio.
Gráfico circular:<br>
Dos categorias.<br>
Cantidad total por categoría.<br>

7. El siguiente gráfico representa el movimiento vehículo desde un punto. Interprétala y responde a las siguientes preguntas:
- a) ¿Cuánto tiempo ha estado andando?. Estuvo andando durante 13 min.
- b) ¿Hasta que distancia máxima del recorrido pudo realizar? 80 m. 
- c) ¿Ha hecho alguna parada? Si duarante 2 min.
- d) ¿Que sucede luego del pico de mts recorrido? El vehículo comienza a regresar.
- e) ¿Cuantos metros recorrio en total? Recorrio 150 mts.

![Ejercicio2](../_src/assets/ejer2.PNG)
 