-- Selecciono la BD
USE Santana2021KM;

-- Creo el SP
DROP PROCEDURE IF EXISTS `BorrarPelicula`;
DELIMITER ##
CREATE PROCEDURE BorrarPelicula (pID INTEGER, OUT pSalida VARCHAR(50))
SALIR: BEGIN
DECLARE AUX DATE;
-- Controlo que el parámetro no este vacio o sea null
	IF (pID IS NULL) THEN
		SET pSalida = 'El ID no puede estar vacio';
        LEAVE SALIR;
	END IF;
    -- Controlo que el parámetro no sea menor que 1
	IF (pID <= 0) THEN
		SET pSalida = 'El ID no puede ser <1';
        LEAVE SALIR;
	END IF;
-- Controlo que la pelicula exista
	IF NOT EXISTS(SELECT Peliculas.idPelicula FROM Peliculas WHERE Peliculas.idPelicula = pID ) THEN
		SET pSalida = 'La pelicula no existe';
        LEAVE SALIR;
	END IF;
-- Controlo que la película no tenga registros asociados
	IF EXISTS (SELECT Registros.idPelicula FROM Registros WHERE Registros.idPelicula = pID) THEN
		SET pSalida = 'La película tiene registros asociados';
        LEAVE SALIR;
	END IF;
-- Luego borro la pelicula en caso de que se pueda
	DELETE FROM Peliculas WHERE Peliculas.idPelicula = pID;
    SET pSalida = 'La pelicula fue borrada';
END ##
DELIMITER ;

-- Inserto para borrar
INSERT INTO Peliculas (idPelicula,titulo,clasificacion,estreno,duracion) VALUES (1100, 'LB2022','G', 2022, 150);
 
-- Pelicula alquilada
CALL BorrarPelicula(1,@Mensaje);
SELECT @Mensaje;
-- ID null
CALL BorrarPelicula(NULL,@Mensaje);
SELECT @Mensaje;
-- ID <=0
CALL BorrarPelicula(0,@Mensaje);
SELECT @Mensaje;
-- ID 1000 (correcto)
CALL BorrarPelicula(1100,@Mensaje);
SELECT @Mensaje;

SELECT * FROM AuditoriaPeliculas;