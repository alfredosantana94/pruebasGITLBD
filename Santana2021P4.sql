-- Selecciono la BD
USE Santana2021KM;

-- Creo un procedimiento almacenado  TotalAlquileres
/* 
Recibe el código de un cliente y muestre por cada película la cantidad de veces que la alquiló. 
Se deberá mostrar el código de la película, su título y la cantidad de veces que fue alquilada. 
Al final del listado deberá mostrar también la cantidad total de alquileres efectuados. La salida
deberá estar ordenada alfabéticamente según el título de la película. 
Incluir en el código la llamada al procedimiento.
*/
DROP PROCEDURE IF EXISTS `TotalAlquileres`;
DELIMITER ##
CREATE PROCEDURE TotalAlquileres(pCodigo INTEGER)
SALIR: BEGIN
-- Debo controlar que el codigo no sea null
	IF (pCodigo IS NULL) THEN
		SELECT 'El codigo no puede estar vacio' AS Mensaje;
        LEAVE SALIR;
	END IF;
-- Debo controlar que exista el cliente
	IF NOT EXISTS (SELECT Clientes.idCliente FROM Clientes WHERE idCliente = pCodigo) THEN
		SELECT 'El cliente no existe' AS Mensaje;
        LEAVE SALIR;
	END IF;
-- Una vez pasados los controles hago la consulta
-- Busco todas las peliculas que esten en los registros y alquileres
-- que además coincida con el idCliente ingresado
(SELECT pel.idPelicula AS ID, pel.titulo AS Pelicula, COUNT(alq.idAlquiler) AS Cantidad
FROM Clientes cli
INNER JOIN Alquileres alq ON cli.idCliente = alq.idCliente
INNER JOIN Registros reg  ON alq.idRegistro = reg.idRegistro
INNER JOIN Peliculas pel ON pel.idPelicula = reg.idPelicula
WHERE cli.idCliente=pCodigo
GROUP BY pel.idPelicula)
UNION
-- Esta tabla es la ultima fila que completa la tabla, se ven todos los alquileres del cliente
(SELECT '---' AS ID, '---' AS Pelicula, COUNT(Alquileres.idAlquiler) AS Cantidad
FROM Peliculas pel2
INNER JOIN Registros ON Registros.idPelicula = pel2.idPelicula
INNER JOIN Alquileres ON Registros.idRegistro = Alquileres.idRegistro
WHERE Alquileres.idCliente = pCodigo)
ORDER BY Cantidad ASC,Pelicula ASC;
END ##
DELIMITER ;
-- Codigo NULL
CALL TotalAlquileres(NULL);
-- Cliente inexistente
CALL TotalAlquileres(10202);
-- Cliente con codigo 1
CALL TotalAlquileres(1);