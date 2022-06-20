-- Selecciono la BD
USE Santana2021KM;

-- Creo la tabla auditorias (No hace falta, solo de molesto)
DROP TABLE IF EXISTS `AuditoriaPeliculas`;
CREATE TABLE IF NOT EXISTS `AuditoriaPeliculas` (
  ID INT NOT NULL AUTO_INCREMENT,	-- ID de Auditoría para peliculas
  idPelicula INTEGER NOT NULL,
  titulo VARCHAR(128) NULL,
  clasificacion VARCHAR(45) NULL,
  estreno INTEGER NULL,
  duracion INTEGER NULL,
  tipo CHAR(1) NOT NULL, -- tipo de operación (I: Inserción, B: Borrado, M: Modificación)
  usuario VARCHAR(45) NOT NULL,  
  maquina VARCHAR(45) NOT NULL,  
  fecha DATETIME NOT NULL,
  PRIMARY KEY (`ID`)
);

-- Creo el trigger para crear Peliculas
/* 
Utilizando triggers, implementar la lógica para que en caso que se quiera crear una
película ya existente según código y/o título se informe mediante un mensaje de error que
no se puede. Incluir el código con las creaciones de películas existentes según código y/o
título y otro inexistente
*/
-- Los trigger no pueden devolver mensajes, uso SIGNAL
DROP TRIGGER IF EXISTS `TriggerCrearPelicula`;
DELIMITER ##
CREATE TRIGGER `TriggerCrearPelicula` 
BEFORE INSERT ON Peliculas FOR EACH ROW
SALIR: BEGIN
-- Verifico que no existe el ID de la pelicula
	IF EXISTS (SELECT Peliculas.idPelicula FROM Peliculas WHERE Peliculas.idPelicula = NEW.idPelicula) THEN
	   SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El ID ingresado esta en uso';
	END IF;
-- Verifico que no exista el titulo de la pelicula
	IF EXISTS (SELECT Peliculas.titulo FROM Peliculas WHERE Peliculas.titulo = NEW.titulo) THEN
	   SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El titulo ingresado esta en uso';
	END IF;
END ##
DELIMITER ;

-- Trigger para crear pelicula
DROP TRIGGER IF EXISTS `TriggerNuevaPelicula`;
DELIMITER ##
CREATE TRIGGER `TriggerNuevaPelicula` 
AFTER INSERT ON Peliculas FOR EACH ROW
BEGIN
-- Si se puede enontces la inserto
	INSERT INTO AuditoriaPeliculas VALUES (
		DEFAULT, 
		NEW.idPelicula,
		NEW.titulo, 
        NEW.clasificacion,
        NEW.estreno,
        NEW.duracion,
		'I', 
		SUBSTRING_INDEX(USER(), '@', 1), 
		SUBSTRING_INDEX(USER(), '@', -1), 
		NOW()
	);
END ##
DELIMITER ;

-- Trigger para borrar pelicula
DROP TRIGGER IF EXISTS `TriggeBorrarPelicula`;
DELIMITER ##
CREATE TRIGGER `TriggeBorrarPelicula` 
AFTER DELETE ON Peliculas FOR EACH ROW
BEGIN
-- Si se puede enontces la inserto
	INSERT INTO AuditoriaPeliculas VALUES (
		DEFAULT, 
		OLD.idPelicula,
		OLD.titulo, 
        OLD.clasificacion,
        OLD.estreno,
        OLD.duracion,
		'B', 
		SUBSTRING_INDEX(USER(), '@', 1), 
		SUBSTRING_INDEX(USER(), '@', -1), 
		NOW()
	);
END ##
DELIMITER ;

-- Pruebo el trigger
-- ID repetido
INSERT INTO Peliculas (idPelicula,titulo,clasificacion,estreno,duracion) VALUES (1, 'ASDQWE ','G', 2020, 67 );
-- Titulo repetido
INSERT INTO Peliculas (idPelicula,titulo,clasificacion,estreno,duracion) VALUES (1000,'ACADEMY DINOSAUR','PG',2003,86);
-- Insercion correcta
INSERT INTO Peliculas (idPelicula,titulo,clasificacion,estreno,duracion) VALUES (1001, 'Santana Juan ','G', 2022, 120);

SELECT * FROM AuditoriaPeliculas;
