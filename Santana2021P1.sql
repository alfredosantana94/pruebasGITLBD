-- Creo la BD
DROP DATABASE IF EXISTS Santana2021KM;
CREATE DATABASE Santana2021KM;

-- Selecciono la DB
USE Santana2021KM;

-- Creo la tabla domicilios
DROP TABLE IF EXISTS `Domicilios`;
CREATE TABLE Domicilios(
-- Creo los atributos
idDomicilio	 INTEGER NOT NULL,
CalleYNumero VARCHAR(60) NOT NULL,
codigoPostal VARCHAR(10)  	 NULL,
telefono     VARCHAR(25) NOT NULL,
municipio	 VARCHAR(25) NOT NULL,
-- Establezco la clave primaria
PRIMARY KEY (idDomicilio),
-- Hago unica la combinacion calle y numero
UNIQUE (CalleYNumero)
)ENGINE INNODB;

-- Creo la tabla peliculas
DROP TABLE IF EXISTS `Peliculas`;
CREATE TABLE Peliculas(
-- Creo los atributos
idPelicula INTEGER NOT NULL,
titulo VARCHAR(128) NOT NULL,
clasificacion VARCHAR(5) NOT NULL
              DEFAULT 'G'
			  CHECK (clasificacion IN ('G','PG','PG-13','R','NC-17')),
estreno INTEGER NULL,
duracion INTEGER NULL,
-- Establezco la clave primaria
PRIMARY KEY (idPelicula),
-- Hago unico el titulo
UNIQUE (titulo)
)ENGINE INNODB;

-- Creo la tabla tiendas
DROP TABLE IF EXISTS `Tiendas`;
CREATE TABLE Tiendas(
-- Creo los atributos
idTienda INTEGER NOT NULL,
idDomicilio INTEGER NOT NULL,
-- Establezco la clave primaria
PRIMARY KEY (idTienda),
-- Establezco los indices
INDEX I_idDomT (idDomicilio),
-- Referencio los indices
CONSTRAINT R_idDomT FOREIGN KEY (idDomicilio) REFERENCES Domicilios(idDomicilio)
)ENGINE INNODB;

-- Creo la tabla Registros
DROP TABLE IF EXISTS `Registros`;
CREATE TABLE Registros(
-- Creo los atributos
idRegistro INTEGER NOT NULL,
idTienda INTEGER NOT NULL,
idPelicula INTEGER NOT NULL,
-- Establezco el indice
PRIMARY KEY (idRegistro),
-- Establezco los indices
INDEX I_idTiR (idRegistro),
INDEX I_PelR (idPelicula),
-- Referencio los indices
CONSTRAINT R_idTiR FOREIGN KEY (idTienda) REFERENCES Tiendas(idtienda),
CONSTRAINT R_idPeR FOREIGN KEY (idPelicula) REFERENCES Peliculas(idPelicula)
)ENGINE INNODB;

-- Creo la tabla clientes
DROP TABLE IF EXISTS `Clientes`;
CREATE TABLE Clientes(
-- Creo los atributos
idCliente INTEGER NOT NULL,
apellidos VARCHAR(50) NOT NULL,
nombres VARCHAR(50) NOT NULL,
correo VARCHAR(50) NULL,
estado CHAR(1) NOT NULL
	   DEFAULT 'E'
	   CHECK (estado IN('E','D')),
idDomicilio INTEGER NOT NULL,
-- Establezco la clave pimaria
PRIMARY KEY (idCliente),
-- Hago unico el correo
UNIQUE (correo),
-- Establezco los indices
INDEX I_idDomC (idDomicilio),
-- Referencio los indices
CONSTRAINT R_idDomC FOREIGN KEY (idDomicilio) REFERENCES Domicilios(idDomicilio)
)ENGINE INNODB;

-- Creo la tabla alquileres
DROP TABLE IF EXISTS `Alquileres`;
CREATE TABLE Alquileres(
-- Creo los atributos
idAlquiler INTEGER NOT NULL,
fechaAlquiler DATETIME NOT NULL,
fechaDevolucion DATETIME NULL,
idcliente INTEGER NOT NULL,
idRegistro INTEGER NOT NULL,
-- Establezco la clcave primaria
PRIMARY KEY (idAlquiler),
-- Establezco los indices
INDEX I_idCliA (idCliente),
INDEX I_idRegA (idRegistro),
-- Referencio los indices
CONSTRAINT R_idCliA FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente),
CONSTRAINT R_idRegA FOREIGN KEY (idRegistro) REFERENCES Registros(idRegistro)
)ENGINE INNODB;

-- Creo la tabla pagos
DROP TABLE IF EXISTS `Pagos`;
CREATE TABLE Pagos(
-- creo los atributos
idPago INTEGER NOT NULL,
idCliente INTEGER NOT NULL,
idAlquiler INTEGER NOT NULL,
importe DECIMAL(5.2) NOT NULL,
fecha DATETIME NOT NULL,
-- Establezco la clave primara
PRIMARY KEY (idPago),
-- Establezco los indices
INDEX idCliP (idCliente),
INDEX idAlqP (idAlquiler),
-- Referencio los indices
CONSTRAINT R_idCliP FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente),
CONSTRAINT R_idAlqP FOREIGN KEY (idAlquiler) REFERENCES Alquileres(idAlquiler)
)ENGINE INNODB;