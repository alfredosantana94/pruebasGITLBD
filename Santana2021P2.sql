-- Selecciono la BD
USE Santana2021KM;
/*
Por cada cliente se deberá mostrar su
código, apellido y nombre (formato: apellido, nombre) y la cantidad total de alquileres. La
salida deberá estar ordenada descendentemente según la cantidad de alquileres, y para el
caso de 2 clientes con la misma cantidad de alquileres, alfabéticamente según apellido y
nombre. Incluir el código con la consulta a la vista.
*/
-- Creo la vista que muestra un ranking VRankingAlquileres con los 10 clientes que mas pelicuals alquilaron
DROP VIEW IF EXISTS `VRankingAlquileres`;
CREATE VIEW VRankingAlquileres AS 
SELECT 
	   ROW_NUMBER() OVER (ORDER BY COUNT(Alquileres.idAlquiler) DESC) AS TOP,
	   Clientes.idCliente AS COD, CONCAT(Clientes.apellidos,", ",Clientes.nombres) AS Cliente,
	   COUNT(Alquileres.idAlquiler) AS Cantidad
FROM   Clientes
INNER JOIN Alquileres ON Clientes.idCliente = Alquileres.idCliente
GROUP BY COD, Cliente
ORDER BY TOP ASC,Cantidad DESC, Cliente ASC
LIMIT 10;

SELECT * FROM VRankingAlquileres;