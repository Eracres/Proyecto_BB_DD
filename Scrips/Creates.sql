------------------------------------TABLA CLIENTE------------------------------------

DROP TABLE CLIENTE CASCADE CONSTRAINT;

CREATE TABLE CLIENTE(
    DNI VARCHAR(10),
    NOMBRE VARCHAR(12) NOT NULL,
    APELLIDO VARCHAR(20) NOT NULL,
    DIRECCION VARCHAR(30) NOT NULL,
    TEL VARCHAR(12) NOT NULL,
    CONSTRAINT PK_CLIENTE1 PRIMARY KEY (DNI)
);

------------------------------------TABLA EMPRESA------------------------------------

DROP TABLE EMPRESA CASCADE CONSTRAINT;

CREATE TABLE EMPRESA(
    CIF VARCHAR(10),
    NOMBRE VARCHAR(25) NOT NULL,
    DIRECCION VARCHAR(30) NOT NULL,
    TEL VARCHAR(15) NOT NULL,
    CONSTRAINT PK_EMPRESA PRIMARY KEY (CIF)
);

------------------------------------TABLA IVA------------------------------------

DROP TABLE IVA CASCADE CONSTRAINT;

CREATE TABLE IVA(
    IVA NUMBER NOT NULL,
    VAL_IVA NUMBER NOT NULL,
    CONSTRAINT PK_IVA PRIMARY KEY (IVA)
);

------------------------------------TABLA REGISTRO_FACTURA------------------------------------

DROP TABLE REGISTRO_FACTURA CASCADE CONSTRAINT;

CREATE TABLE REGISTRO_FACTURA(
    N_FACTURA VARCHAR(20),
    FECHA DATE NOT NULL,
    CONSTRAINT PK_FACTURA PRIMARY KEY (N_FACTURA)
);

------------------------------------TABLA PRODUCTOS------------------------------------

DROP TABLE PRODUCTO CASCADE CONSTRAINT;

CREATE TABLE PRODUCTO(
    C_PRODUCTO VARCHAR(10),
    N_PRODUCTO VARCHAR(45),
    PRECIO NUMBER NOT NULL,
    CIF VARCHAR(10) NOT NULL,
    IVA NUMBER NOT NULL,
    CONSTRAINT PK_PRODUCTO1 PRIMARY KEY (C_PRODUCTO),
    CONSTRAINT FK_EMPRESA1 FOREIGN KEY (CIF) REFERENCES EMPRESA(CIF),
    CONSTRAINT FK_IVA FOREIGN KEY (IVA) REFERENCES IVA(IVA)
);

------------------------------------TABLA REGISTRO_PEDIDO------------------------------------

DROP TABLE REGISTRO_PEDIDO CASCADE CONSTRAINT;

CREATE TABLE REGISTRO_PEDIDO(
    N_PEDIDO VARCHAR(20),
    DNI VARCHAR(10) NOT NULL,
    FECHA DATE NOT NULL,
    CONSTRAINT PK_PEDIDIO1 PRIMARY KEY (N_PEDIDO),
    CONSTRAINT FK_CLIENTE1 FOREIGN KEY (DNI) REFERENCES CLIENTE(DNI)
);

------------------------------------TABLA LINEA_PEDIDO------------------------------------

DROP TABLE LINEA_PEDIDO CASCADE CONSTRAINT;

CREATE TABLE LINEA_PEDIDO(
    N_LINEA_P VARCHAR(10),
    N_PEDIDO VARCHAR(20),
    CANTIDAD NUMBER NOT NULL,
    C_PRODUCTO VARCHAR(10) NOT NULL,
    CONSTRAINT PK_L_PEDIDO PRIMARY KEY (N_LINEA_P, N_PEDIDO),
    CONSTRAINT FK_PRODUCTO1 FOREIGN KEY (C_PRODUCTO) REFERENCES PRODUCTO(C_PRODUCTO),
    CONSTRAINT FK_PEDIDO1 FOREIGN KEY (N_PEDIDO) REFERENCES REGISTRO_PEDIDO(N_PEDIDO)
);

------------------------------------TABLA REGISTRO_ALBARAN------------------------------------

DROP TABLE REGISTRO_ALBARAN CASCADE CONSTRAINT;

CREATE TABLE REGISTRO_ALBARAN(
    N_ALBARAN VARCHAR(20),
    FECHA DATE NOT NULL,
    N_FACTURA VARCHAR(20),
    N_PEDIDO VARCHAR(20),
    CONSTRAINT PK_ALBARAN PRIMARY KEY (N_ALBARAN),
    CONSTRAINT FK_FACTURA1 FOREIGN KEY (N_FACTURA) REFERENCES REGISTRO_FACTURA(N_FACTURA),
    CONSTRAINT FK_PEDIDO2 FOREIGN KEY (N_PEDIDO) REFERENCES REGISTRO_PEDIDO(N_PEDIDO)
);

------------------------------------TABLA LINEA_ALBARAN------------------------------------

DROP TABLE LINEA_ALBARAN CASCADE CONSTRAINT;

CREATE TABLE LINEA_ALBARAN(
    N_LINEA_A VARCHAR(10),
    N_ALBARAN VARCHAR(20),
    CANTIDAD NUMBER NOT NULL,
    C_PRODUCTO VARCHAR(10),
    CONSTRAINT PK_L_ALBARAN PRIMARY KEY (N_LINEA_A, N_ALBARAN),
    CONSTRAINT FK_N_ALBARAN1 FOREIGN KEY (N_ALBARAN) REFERENCES REGISTRO_ALBARAN(N_ALBARAN),
    CONSTRAINT FK_PRODUCTO2 FOREIGN KEY (C_PRODUCTO) REFERENCES PRODUCTO(C_PRODUCTO)
);

------------------------------------TABLA TRIGGERS------------------------------------

DROP TABLE auditar_empresa CASCADE CONSTRAINT;

CREATE TABLE auditar_empresa(
		USUARIO VARCHAR2(10),
        FECHA DATE,
        NOMBRE_TABLA VARCHAR2(20),
        ACCION VARCHAR2(65)
	);
