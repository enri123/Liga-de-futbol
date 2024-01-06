-- Active: 1703532910590@@localhost@3306@test
--Fichero 1: altas.sql

--1.  Crear una base de datos que se denomine “liga_futbol”.
Create DATABASE liga_futbol;
use liga_futbol;

/*2.  Dentro de “liga_futbol” crear dos tablas: “equipos” y “partidos”.
En esta tabla se asocian mediante los campos registro de la tabla equipos con los campos id_equipo1 e id_equipo2 de esta tabla. 
Los campos resultado_equipo1 y resultado_equipo2 indican los goles marcados por cada equipo en ese partido. */
-- Crear la tabla "equipos"
CREATE TABLE equipos (
    registro INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(30) UNIQUE,
    nombre_entrenador VARCHAR(35),
    nombre_campo_futbol VARCHAR(30),
    poblacion VARCHAR(25),
    anio_fundacion INT,
    anotaciones BLOB
);

-- Crear la tabla "partidos"
CREATE TABLE partidos (
    registro INT AUTO_INCREMENT PRIMARY KEY,
    id_equipo1 INT,
    resultado_equipo1 INT,
    id_equipo2 INT,
    resultado_equipo2 INT,
    FOREIGN KEY (id_equipo1) REFERENCES equipos(registro),
    FOREIGN KEY (id_equipo2) REFERENCES equipos(registro)
);

/*3.  Introducir de 8 a 10 registros en cada tabla con datos variados y coherentes, que puedes inventar, para que sea posible realizar consultas con resultados. 
Conviene que leas antes el tipo de consultas que se van a pedir para introducir los datos que convenga. Las consultas aparecen en el punto 4 de los dos primeros scripts sql.*/

INSERT INTO equipos (nombre, nombre_entrenador, nombre_campo_futbol, poblacion, anio_fundacion, anotaciones)
VALUES 
('Real Madrid', 'Zinedine Zidane', 'Santiago Bernabeu', 'Madrid', 1902, 'Real Madrid'),
('FC Barcelona', 'Ronald Koeman', 'Camp Nou', 'Barcelona', 1899, 'Barcelona'),
('Atlético de Madrid', 'Diego Simeone', 'Wanda Metropolitano', 'Madrid', 1903, 'Atlético de Madrid'),
('Valencia CF', 'Javi Gracia', 'Mestalla', 'Valencia', 1919, 'Valencia CF'),
('Sevilla FC', 'Julen Lopetegui', 'Ramón Sánchez Pizjuán', 'Sevilla', 1890, 'Sevilla FC'),
('Real Betis', 'Manuel Pellegrini', 'Benito Villamarín', 'Sevilla', 1907, 'Real Betis'),
('Villarreal CF', 'Unai Emery', 'Estadio de la Cerámica', 'Villarreal', 1923, 'Villarreal CF'),
('Athletic Club', 'Marcelino García Toral', 'San Mamés', 'Bilbao', 1898, 'Athletic Club'),
('Real Sociedad', 'Imanol Alguacil', 'Reale Arena', 'San Sebastián', 1909, 'Real Sociedad'),
('Espanyol', 'Vicente Moreno', 'RCDE Stadium', 'Barcelona', 1900, 'Espanyol');

-- Partidos
INSERT INTO partidos (id_equipo1, resultado_equipo1, id_equipo2, resultado_equipo2)
VALUES
(1, 3, 2, 2),
(3, 1, 4, 0),
(5, 2, 6, 1),
(7, 4, 8, 3),
(9, 0, 10, 1),
(2, 2, 3, 2),
(4, 3, 5, 1),
(6, 0, 7, 1),
(8, 2, 9, 2),
(10, 3, 1, 4);

/*4.  Mostrar la información introducida en las dos tablas de la forma siguiente:
Todos los campos de todos los registros de la tabla “equipos”.*/
Select * from equipos;

/*Los campos nombre, entrenador y nombre del campo de fútbol sólo de los equipos de una determinada población.*/
SELECT nombre, nombre_entrenador, nombre_campo_futbol
FROM equipos
WHERE poblacion = 'Madrid';

/*Los campos nombre del equipo, población y anotaciones de los equipos cuyo nombre empieza por el carácter 'B'.*/
SELECT nombre, poblacion, anotaciones
FROM equipos
WHERE nombre LIKE 'B%';

/*El número de equipos y población agrupados por la población ordenados decrecientemente por el número de equipos.*/
SELECT poblacion, COUNT(*) AS num_equipos
FROM equipos
GROUP BY poblacion
ORDER BY num_equipos DESC;

/* Año de la fundación del primer equipo. */
SELECT MIN(anio_fundacion) FROM equipos;

/*Partidos jugados: nombre del equipo1, nombre del equipo2, resultado equipo1, resultado equipo2 ordenados por el nombre del equipo1. */
SELECT e1.nombre AS equipo1, e2.nombre AS equipo2, p.resultado_equipo1, p.resultado_equipo2
FROM partidos p
JOIN equipos e1 ON p.id_equipo1 = e1.registro
JOIN equipos e2 ON p.id_equipo2 = e2.registro
ORDER BY equipo1;

/*Los campos nº total de partidos jugados (campo calculado) y nombre del equipo ordenado decrecientemente por el nº de partidos jugados.*/
SELECT equipo, SUM(num_partidos) AS total_partidos_jugados
FROM (
    SELECT e.nombre AS equipo, COUNT(*) AS num_partidos
    FROM partidos p
    JOIN equipos e ON p.id_equipo1 = e.registro
    GROUP BY equipo
    UNION ALL
    SELECT e.nombre AS equipo, COUNT(*) AS num_partidos
    FROM partidos p
    JOIN equipos e ON p.id_equipo2 = e.registro
    GROUP BY equipo
) AS partidos_equipo
GROUP BY equipo
ORDER BY total_partidos_jugados DESC;
-- Fichero 2: modifica.sql

-- 1. Mostrar todos los campos de todos los registros de las dos tablas.
SELECT * FROM equipos;
SELECT * FROM partidos;

-- 2. Actualizar los datos de algunos registros de las dos tablas de forma que los cambios afecten a varios campos.
-- Por ejemplo, actualizamos el nombre del entrenador y la población de algunos equipos
UPDATE equipos SET nombre_entrenador = 'Nuevo Entrenador', poblacion = 'Nueva Poblacion' WHERE registro IN (1, 3, 5);

-- 3. Volver a mostrar todos los campos de todos los registros de las dos tablas.
SELECT * FROM equipos;
SELECT * FROM partidos;

-- 4. Mostrar la información introducida en las dos tablas de la forma siguiente:
-- Mostrar el número de registro, el nombre equipo, la población y año de fundación de aquellos equipos fundados después de 1940.
SELECT registro, nombre, poblacion, anio_fundacion
FROM equipos
WHERE anio_fundacion > 1940;

-- Hallar la media de puntos de cada partido entre los dos equipos.
SELECT ROUND(AVG(resultado_equipo1 + resultado_equipo2), 2) 
FROM partidos;

-- Hallar la media de los goles de cada equipo y nombre del equipo, ordenar el resultado decrecientemente por el nº de goles.
SELECT nombre, ROUND(AVG(goles)) AS media_goles
FROM (
    SELECT id_equipo1 AS id_equipo, resultado_equipo1 AS goles FROM partidos
    UNION ALL
    SELECT id_equipo2 AS id_equipo, resultado_equipo2 AS goles FROM partidos
) AS goles_equipo
JOIN equipos ON goles_equipo.id_equipo = equipos.registro
GROUP BY nombre
ORDER BY media_goles DESC;

-- Hallar la diferencia de puntos entre todos los partidos de los equipos.
SELECT 
    e1.nombre AS equipo1, 
    e2.nombre AS equipo2, 
    ABS(resultado_equipo1 - resultado_equipo2) AS diferencia_puntos
FROM partidos
JOIN equipos e1 ON partidos.id_equipo1 = e1.registro
JOIN equipos e2 ON partidos.id_equipo2 = e2.registro
ORDER BY diferencia_puntos DESC;

-- Hallar el mayor número de partidos ganados por cada equipo.
SELECT nombre, MAX(partidos_ganados) AS max_partidos_ganados
FROM (
    SELECT id_equipo1 AS id_equipo, COUNT(*) AS partidos_ganados FROM partidos WHERE resultado_equipo1 > resultado_equipo2 GROUP BY id_equipo1
    UNION ALL
    SELECT id_equipo2 AS id_equipo, COUNT(*) AS partidos_ganados FROM partidos WHERE resultado_equipo2 > resultado_equipo1 GROUP BY id_equipo2
) AS partidos_ganados_equipo
JOIN equipos ON partidos_ganados_equipo.id_equipo = equipos.registro
GROUP BY nombre
ORDER BY max_partidos_ganados DESC;


-- Fichero 3: elimina.sql

-- 1. Mostrar los campos nombre, nombre del entrenador, nombre del campo de fútbol, población y año de fundación de todos los equipos.
SELECT nombre, nombre_entrenador, nombre_campo_futbol, poblacion, anio_fundacion FROM equipos;

-- 2. Mostrar los campos nombre, nombre del entrenador, nombre del campo de fútbol, población y año de fundación de todos los equipos que no hayan jugado ningún partido.
SELECT e.nombre, e.nombre_entrenador, e.nombre_campo_futbol, e.poblacion, e.anio_fundacion
FROM equipos e
LEFT JOIN partidos p ON e.registro = p.id_equipo1 OR e.registro = p.id_equipo2
WHERE p.registro IS NULL;

-- 3. Borrar los equipos que no hayan jugado ningún partido.
DELETE FROM equipos
WHERE registro IN (
    SELECT e.registro
    FROM equipos e
    LEFT JOIN partidos p ON e.registro = p.id_equipo1 OR e.registro = p.id_equipo2
    WHERE p.registro IS NULL
);

-- 4. Mostrar los campos nombre, nombre del entrenador, nombre del campo de fútbol, población y año de fundación de los equipos no borrados.
SELECT nombre, nombre_entrenador, nombre_campo_futbol, poblacion, anio_fundacion FROM equipos;

-- 5. Borrar las tablas de la base de datos liga_futbol.
DROP TABLE partidos;
DROP TABLE equipos;

-- 6. Borrar la base de datos liga_futbol.
DROP DATABASE liga_futbol;
