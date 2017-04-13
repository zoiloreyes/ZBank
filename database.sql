CREATE DATABASE ZBANK;
USE ZBANK;


CREATE TABLE TIPO_USUARIO(
	IDTIPO INT NOT NULL AUTO_INCREMENT,
	NOMBRE VARCHAR(200) NOT NULL,
	DESCRIPCION VARCHAR(200),

	CONSTRAINT PK_TIPOUSR PRIMARY KEY (IDTIPO),
	CONSTRAINT UC_NOMBRETIPOUSR UNIQUE(NOMBRE)
);

INSERT INTO TIPO_USUARIO(NOMBRE, DESCRIPCION) VALUES("Cliente","usuario del sistema con acceso limitado");
INSERT INTO TIPO_USUARIO(NOMBRE, DESCRIPCION) VALUES("Administrador","Encargado del sistema");


CREATE TABLE ESTADO_USUARIO(
	IDESTADO INT NOT NULL AUTO_INCREMENT,
	NOMBRE VARCHAR(200) NOT NULL,
	DESCRIPCION VARCHAR(200),

	CONSTRAINT PK_ESTADOUSR PRIMARY KEY(IDESTADO),
	CONSTRAINT UC_NOMBREESTADOUSR UNIQUE (NOMBRE)
);
INSERT INTO ESTADO_USUARIO(NOMBRE, DESCRIPCION) VALUES("Activo","El usuario puede realizar retiros normalmente");
INSERT INTO ESTADO_USUARIO(NOMBRE, DESCRIPCION) VALUES("Bloqueado","El usuario no puede retirar su dinero");


CREATE TABLE USUARIO(
	IDUSUARIO INT NOT NULL AUTO_INCREMENT,
	NOMBREUSUARIO VARCHAR(50) NOT NULL,
	CEDULA VARCHAR(30) NOT NULL,
	TELEFONO VARCHAR(20) NOT NULL,	
	CORREO VARCHAR(200) NOT NULL,
	NOMBRE VARCHAR(40) NOT NULL,
	APELLIDO VARCHAR(40) NOT NULL,
	CONTRASENA VARCHAR(30) NOT NULL,
	GENERO VARCHAR(30) NOT NULL,
	TIPO INT NOT NULL DEFAULT 1,
	ESTADO INT NOT NULL DEFAULT 1,

	CONSTRAINT UC_CEDULA UNIQUE(CEDULA),
	CONSTRAINT PK_USUARIO PRIMARY KEY (IDUSUARIO),
	CONSTRAINT UC_NOMBREUSUARIO UNIQUE (NOMBREUSUARIO),
	CONSTRAINT UC_CORREO UNIQUE(CORREO),
	CONSTRAINT FK_TIPOUSR FOREIGN KEY(TIPO) REFERENCES TIPO_USUARIO(IDTIPO),
	CONSTRAINT FK_ESTADOUSR FOREIGN KEY(ESTADO) REFERENCES ESTADO_USUARIO(IDESTADO)
);

CREATE TABLE MONEDA(
	IDMONEDA INT NOT NULL AUTO_INCREMENT,
	NOMBRE VARCHAR(200) NOT NULL,
	ABREVIATURA VARCHAR(10) NOT NULL,

	CONSTRAINT PK_MONEDA PRIMARY KEY(IDMONEDA)
);
INSERT INTO MONEDA(NOMBRE, ABREVIATURA) VALUES("Peso dominicano","DOP");
INSERT INTO MONEDA(NOMBRE, ABREVIATURA) VALUES("Dolar estadounidense","USD");



CREATE TABLE ESTADO_CUENTA(
	IDESTADO INT NOT NULL AUTO_INCREMENT,
	NOMBRE VARCHAR(200) NOT NULL,
	DESCRIPCION VARCHAR(200),

	CONSTRAINT PK_ESTADOCUENTA PRIMARY KEY(IDESTADO),
	CONSTRAINT UC_NOMBREESTADOCUENTA UNIQUE (NOMBRE)
);
INSERT INTO ESTADO_CUENTA(NOMBRE, DESCRIPCION) VALUES("Pendiente","La cuenta esta pendiente a ser aprobada por un administrador");
INSERT INTO ESTADO_CUENTA(NOMBRE, DESCRIPCION) VALUES("Aprobada","La cuenta esta funcional");
INSERT INTO ESTADO_CUENTA(NOMBRE, DESCRIPCION) VALUES("Cancelada","La cuenta no se puede usar");


CREATE TABLE CUENTA_AHORRO(
	IDCUENTA INT NOT NULL AUTO_INCREMENT,
	BALANCE DECIMAL(18,2) DEFAULT 0,
	FECHA_APERTURA DATETIME DEFAULT CURRENT_TIMESTAMP,
	USUARIO INT NOT NULL,
	MONEDA INT NOT NULL DEFAULT 1,
	ESTADO INT NOT NULL DEFAULT 2,
	CONSTRAINT PK_CUENTAAHORRO PRIMARY KEY(IDCUENTA),
	CONSTRAINT CHK_BALANCE CHECK (BALANCE >= 0),
	CONSTRAINT FK_CUENTAMONEDA FOREIGN KEY(MONEDA) 
	REFERENCES MONEDA(IDMONEDA),
	CONSTRAINT FK_CUENTAESTADO FOREIGN KEY(ESTADO)
	REFERENCES ESTADO_CUENTA(IDESTADO),
	CONSTRAINT FK_CUENTAUSUARIO FOREIGN KEY(USUARIO) REFERENCES USUARIO(IDUSUARIO)
);

CREATE TABLE ESTADO_TARJETA(
	IDESTADO INT NOT NULL AUTO_INCREMENT,
	NOMBRE VARCHAR(200) NOT NULL,
	DESCRIPCION VARCHAR(200),

	CONSTRAINT PK_ESTADOTARJETA PRIMARY KEY(IDESTADO),
	CONSTRAINT UC_NOMBREESTADOTARJETA UNIQUE (NOMBRE)
);
INSERT INTO ESTADO_TARJETA(NOMBRE, DESCRIPCION) VALUES("Pendiente","La cuenta esta pendiente a ser aprobada por un administrador");
INSERT INTO ESTADO_TARJETA(NOMBRE, DESCRIPCION) VALUES("Aprobada","La cuenta esta funcional");
INSERT INTO ESTADO_TARJETA(NOMBRE, DESCRIPCION) VALUES("Cancelada","La cuenta no se puede usar");


CREATE TABLE TARJETA_DEBITO(
	IDTARJETA INT NOT NULL AUTO_INCREMENT,
	FECHA_CREACION DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	FECHA_EXPIRACION DATETIME NOT NULL,
	CUENTA INT NOT NULL,
	CONSTRAINT PK_TARJETADEBITO PRIMARY KEY (IDTARJETA),
	CONSTRAINT FK_TARJETACUENTA FOREIGN KEY (CUENTA) REFERENCES CUENTA_AHORRO(IDCUENTA)
);

CREATE TABLE ESTADO_TRANSACCION(
	IDESTADO INT NOT NULL AUTO_INCREMENT,
	NOMBRE VARCHAR(200) NOT NULL,
	DESCRIPCION VARCHAR(200),

	CONSTRAINT PK_ESTADOTRANSACCION PRIMARY KEY(IDESTADO),
	CONSTRAINT UC_NOMBREESTADOTRANSACCION UNIQUE (NOMBRE)
);

INSERT INTO ESTADO_TRANSACCION(NOMBRE, DESCRIPCION) VALUES("Completada","La transaccion fue completada");
INSERT INTO ESTADO_TRANSACCION(NOMBRE, DESCRIPCION) VALUES("En revision","La transaccion está en revision");
INSERT INTO ESTADO_TRANSACCION(NOMBRE, DESCRIPCION) VALUES("Revisada","La transaccion no tiene problemas");
INSERT INTO ESTADO_TRANSACCION(NOMBRE, DESCRIPCION) VALUES("Retornada","La transaccion fue devuelta	");


CREATE TABLE TRANSACCION(
	IDTRANSACCION INT NOT NULL AUTO_INCREMENT,
	FECHA DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	LATITUD VARCHAR(30),
	LONGITUD VARCHAR(30),
	CUENTA_ORIGEN INT NOT NULL,
	CUENTA_DESTINO INT NOT NULL,
	MONTO DECIMAL(18,2) DEFAULT 0,
	ESTADO INT NOT NULL DEFAULT 1,
	CONSTRAINT PK_TRANSACCION PRIMARY KEY(IDTRANSACCION),
	CONSTRAINT CHK_MONTO CHECK (MONTO >= 0),
	CONSTRAINT FK_CUENTAORIGEN FOREIGN KEY(CUENTA_ORIGEN)
	REFERENCES CUENTA_AHORRO(IDCUENTA),
	CONSTRAINT FK_CUENTADESTINO FOREIGN KEY(CUENTA_DESTINO)
	REFERENCES CUENTA_AHORRO(IDCUENTA),
	CONSTRAINT FK_TRANSACCIONESTADO FOREIGN KEY(ESTADO)
	REFERENCES ESTADO_TRANSACCION(IDESTADO)

);


CREATE TABLE TASA_CAMBIO(
	IDTASA INT NOT NULL AUTO_INCREMENT,
	MONEDA_ORIGEN INT NOT NULL,
	MONEDA_DESTINO INT NOT NULL,
	TASA DECIMAL(10,2),

	CONSTRAINT CHK_TASA CHECK (TASA>=0),
	CONSTRAINT PK_TASA PRIMARY KEY(IDTASA),
	CONSTRAINT FK_TASAMONEDAORIGEN FOREIGN KEY(MONEDA_ORIGEN) REFERENCES MONEDA(IDMONEDA),
	CONSTRAINT FK_TASAMONEDADESTINO FOREIGN KEY(MONEDA_DESTINO) REFERENCES MONEDA(IDMONEDA)
);

CREATE TABLE BILLETE(
	IDBILLETE INT NOT NULL AUTO_INCREMENT,
	MONEDA INT NOT NULL,
	VALOR INT NOT NULL,
	CONSTRAINT CHK_VALORBILLETE CHECK (VALOR>0),
	CONSTRAINT PK_IDBILLETE PRIMARY KEY(IDBILLETE),
	CONSTRAINT FK_BILLETEMONEDA FOREIGN KEY(MONEDA) REFERENCES MONEDA(IDMONEDA)
);