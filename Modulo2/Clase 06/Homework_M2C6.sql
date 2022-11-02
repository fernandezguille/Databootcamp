-- Punto 2: Cohortes N° 1245 y N° 1246, se solicita que las elimine de la tabla
DELETE FROM cohorte
WHERE idCohorte IN (1245,1246);

-- Punto 3: Cohorte N°1243, la nueva fecha de inicio será el 16/05
UPDATE cohorte
SET fecha_inicio = '2022-05-16'
WHERE idCohorte = 1243;

-- Punto 4: El alumno N° 165 solicito el cambio de su Apellido por “Ramirez”
UPDATE alumno
SET apellido = 'Ramirez'
WHERE idAlumno = 165;

-- Punto 5: Listado de alumnos de la Cohorte N°1243 que incluya la fecha de ingreso
SELECT idAlumno, Nombre, Apellido, Fecha_Ingreso from alumno
WHERE idCohorte = 1243;

-- Punto 6: Listado de los instructores que dictan la carrera de Full Stack Developer
SELECT DISTINCT i.idInstructor, i.Nombre, i.Apellido 
FROM instructor i
INNER JOIN cohorte co ON (co.idInstructor = i.idInstructor)
INNER JOIN carrera ca ON (co.idCarrera = ca.idCarrera)
WHERE ca.nombre LIKE '%Full%';
-- Opción 2, con subconsulta
/*SELECT nombre, apellido
FROM instructor
WHERE idInstructor IN (SELECT idInstructor FROM cohorte WHERE idCarrera = 1);*/

-- Punto 7: Que alumnos formaron parte de la cohorte N° 1235
SELECT * from alumno
WHERE idcohorte = 1235;

-- Punto 8: Del listado anterior se desea saber quienes ingresaron en el año 2019
SELECT * from alumno
WHERE idcohorte = 1235 AND YEAR(Fecha_ingreso) = '2019';

/* En el M3 profudizaremos en el aprendizaje de SQL, 
pero aprovechemos lo que sabemos hasta aquí para entender como funcionan las relacionales. */
SELECT a.Nombre, a.Apellido, a.Fecha_Nacimiento, ca.nombre AS Nombre_Carrera
FROM alumno a
INNER JOIN cohorte co ON a.idcohorte = co.idCohorte
INNER JOIN carrera ca ON co.idcarrera = ca.idCarrera;
/* Punto 9.a. ¿Que campos permiten que se puedan acceder al nombre de la carrera?
Con idCarrera se puede acceder a ca.Nombre
-- Punto 9.b. ¿Que tipo de relación existe entre el nombre la tabla cohortes y alumnos?
Más de un alumno pertenece a una cohorte, la relación es de N a 1.*/

/* Punto 9.c. Proponga dos opciones para filtrar el listado solo por los alumnos que pertenecen a 'Full Stack Developer',
utilizando LIKE y NOT LIKE. ¿Cual de las dos opciones es la manera correcta de hacerlo? ¿Por que? */
SELECT a.Nombre, a.Apellido, a.Fecha_Nacimiento, ca.nombre AS Nombre_Carrera
FROM alumno a
INNER JOIN cohorte co ON a.idcohorte = co.idCohorte
INNER JOIN carrera ca ON co.idcarrera = ca.idCarrera
WHERE ca.nombre LIKE '%Full Stack%';
-- WHERE ca.nombre NOT LIKE '%Data%';

/* Punto 9.d. Proponga dos opciones para filtrar el listado solo por los alumnos que pertenecen a 'Full Stack Developer',
utilizando " = " y " != ". ¿Cual de las dos opciones es la manera correcta de hacerlo? ¿Por que? */
SELECT a.Nombre, a.Apellido, a.Fecha_Nacimiento, ca.nombre AS Nombre_Carrera
FROM alumno a
INNER JOIN cohorte co ON a.idcohorte = co.idCohorte
INNER JOIN carrera ca ON co.idcarrera = ca.idCarrera
WHERE ca.nombre = 'Full Stack Developer';
-- WHERE ca.nombre != 'Data Science';

-- Punto 9.e. ¿Como emplearía el filtrado utilizando el campo idCarrera?
SELECT a.Nombre, a.Apellido, a.Fecha_Nacimiento, ca.nombre AS Nombre_Carrera
FROM alumno a
INNER JOIN cohorte co ON a.idcohorte = co.idCohorte
INNER JOIN carrera ca ON co.idcarrera = ca.idCarrera
WHERE ca.idCarrera = 1;