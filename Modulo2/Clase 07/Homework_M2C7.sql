-- 1. ¿Cuantas carreras tiene Henry?
SELECT count(*) AS Total_de_carreras
FROM Carrera;

-- 2. ¿Cuantos alumnos hay en total?
SELECT count(*) AS Total_de_alumnos
FROM Alumno;

-- 3. ¿Cuantos alumnos tiene cada cohorte?
SELECT idCohorte, count(*) AS Cantidad_de_alumnos
FROM Alumno
GROUP BY idCohorte;

-- 4. Confecciona un listado de los alumnos ordenado por los últimos alumnos que ingresaron, con nombre y apellido en un solo campo.
SELECT CONCAT(Nombre," ",Apellido) AS Nombre_completo, Fecha_ingreso
FROM Alumno
ORDER BY Fecha_ingreso DESC;

-- 5. ¿Cual es el nombre del primer alumno que ingreso a Henry?
SELECT Nombre, Apellido
FROM Alumno
ORDER BY Fecha_ingreso ASC
LIMIT 1;

-- 6. ¿En que fecha ingreso?
SELECT date_format(MIN(Fecha_ingreso), '%d/%m/%Y') AS Fecha_ingreso
FROM Alumno;

-- 7. ¿Cual es el nombre del ultimo alumno que ingreso a Henry?
SELECT Nombre, Apellido
FROM Alumno
ORDER BY Fecha_ingreso DESC
LIMIT 1;

-- 8. La función YEAR le permite extraer el año de un campo date, utilice esta función y especifique cuantos alumnos ingresaron a Henry por año.
SELECT YEAR(Fecha_ingreso) AS Año_de_ingreso, count(*) AS Cantidad_de_alumnos
FROM Alumno
GROUP BY 1
ORDER BY 1;

-- 9. ¿Cuantos alumnos ingresaron por semana a henry?, indique también el año. WEEKOFYEAR() -- Si se usa WEEK se puede cambiar el criterio
SELECT YEAR(Fecha_ingreso) AS Año_de_ingreso, WEEK(Fecha_ingreso, 6) AS Semana_del_año, count(*) AS Cantidad_de_alumnos
FROM Alumno
GROUP BY 2, 1
ORDER BY 2, 1;

-- 10. ¿En que años ingresaron más de 20 alumnos?
SELECT YEAR(Fecha_ingreso) AS Año_de_ingreso, count(*) AS Cantidad_de_alumnos
FROM Alumno
GROUP BY 1
HAVING Cantidad_de_alumnos > 20
ORDER BY 1;

/* 11. Investigue las funciones TIMESTAMPDIFF() y CURDATE(). ¿Podría utilizarlas para saber cual es la edad de los instructores?
¿Como podrías verificar si la función calcula años completos? Utiliza DATE_ADD()*/
SELECT Nombre, Apellido, TIMESTAMPDIFF(Year, Fecha_Nacimiento, Curdate()) AS Edad, Fecha_Nacimiento,
	date_add(curdate(), INTERVAL -timestampdiff(DAY,Fecha_Nacimiento,curdate()) DAY) AS Verificación_nacimiento
FROM Instructor
ORDER BY 3 DESC;

-- 12. Calcula: 
-- a. La edad de cada alumno.
SELECT Nombre, Apellido, TIMESTAMPDIFF(Year, Fecha_Nacimiento, Curdate()) AS Edad
FROM Alumno;

-- b. La edad promedio de los alumnos de henry.
SELECT ROUND(AVG(TIMESTAMPDIFF(Year, Fecha_Nacimiento, Curdate())),0) AS Edad_promedio
FROM Alumno;

-- c. La edad promedio de los alumnos de cada cohorte.
SELECT idCohorte, ROUND(AVG(TIMESTAMPDIFF(Year, Fecha_Nacimiento, Curdate())),0) AS Edad_promedio
FROM Alumno
GROUP BY 1;

-- 13. Elabora un listado de los alumnos que superan la edad promedio de Henry.
-- @promedio:= guarda en una variable global lo que se indique en la query y puedo usarla luego
SELECT @promedio := avg(TIMESTAMPDIFF(year, Fecha_Nacimiento, CURDATE())) FROM alumno;

SELECT Nombre, Apellido, timestampdiff(YEAR,Fecha_Nacimiento,curdate()) AS Edad
FROM alumno
HAVING Edad > @promedio
ORDER BY 3 DESC;

-- Query para arreglar el error de tipeo que desplazaba los promedios
UPDATE Alumno
SET Fecha_Nacimiento = '2002-01-02'
WHERE idAlumno = 127;