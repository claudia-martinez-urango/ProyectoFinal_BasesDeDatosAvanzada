DROP DATABASE IF EXISTS ride_hailing;
CREATE DATABASE ride_hailing;
USE ride_hailing;

-- =========================================
-- TABLA: COMPANY
-- =========================================
CREATE TABLE company (
    id_company BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    cif VARCHAR(20) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    email VARCHAR(120),
    activa BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB;

-- =========================================
-- TABLA: USUARIO
-- =========================================
CREATE TABLE usuario (
    id_usuario BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(80) NOT NULL,
    apellidos VARCHAR(120) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    fecha_alta DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB;

-- =========================================
-- TABLA: DRIVER
-- Especialización de usuario
-- =========================================
CREATE TABLE driver (
    id_usuario BIGINT PRIMARY KEY,
    id_company BIGINT NOT NULL,
    num_licencia VARCHAR(50) NOT NULL UNIQUE,
    estado_driver VARCHAR(30) NOT NULL,
    fecha_alta_driver DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_driver_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_driver_company
        FOREIGN KEY (id_company) REFERENCES company(id_company)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =========================================
-- TABLA: RIDER
-- Especialización de usuario
-- =========================================
CREATE TABLE rider (
    id_usuario BIGINT PRIMARY KEY,
    CONSTRAINT fk_rider_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =========================================
-- TABLA: VEHICULO
-- =========================================
CREATE TABLE vehiculo (
    id_vehiculo BIGINT PRIMARY KEY AUTO_INCREMENT,
    matricula VARCHAR(20) NOT NULL UNIQUE,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    color VARCHAR(30),
    plazas INT NOT NULL,
    anio INT,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT chk_vehiculo_plazas CHECK (plazas > 0),
    CONSTRAINT chk_vehiculo_anio CHECK (anio IS NULL OR anio >= 1900)
) ENGINE=InnoDB;

-- =========================================
-- TABLA: DRIVER_VEHICULO
-- Histórico de asignación conductor-vehículo
-- =========================================
CREATE TABLE driver_vehiculo (
    id_usuario_driver BIGINT NOT NULL,
    id_vehiculo BIGINT NOT NULL,
    fecha_desde DATETIME NOT NULL,
    fecha_hasta DATETIME DEFAULT NULL,
    PRIMARY KEY (id_usuario_driver, id_vehiculo, fecha_desde),
    CONSTRAINT fk_drivervehiculo_driver
        FOREIGN KEY (id_usuario_driver) REFERENCES driver(id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_drivervehiculo_vehiculo
        FOREIGN KEY (id_vehiculo) REFERENCES vehiculo(id_vehiculo)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT chk_fechas_driver_vehiculo
        CHECK (fecha_hasta IS NULL OR fecha_hasta >= fecha_desde)
) ENGINE=InnoDB;

-- =========================================
-- TABLA: VIAJE
-- =========================================
CREATE TABLE viaje (
    id_viaje BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_rider BIGINT NOT NULL,
    id_driver_asignado BIGINT DEFAULT NULL,
    estado VARCHAR(30) NOT NULL,
    fecha_solicitud DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_aceptacion DATETIME DEFAULT NULL,
    fecha_inicio DATETIME DEFAULT NULL,
    fecha_fin DATETIME DEFAULT NULL,

    origen_lat DECIMAL(10,7) NOT NULL,
    origen_lng DECIMAL(10,7) NOT NULL,
    origen_direccion VARCHAR(255) NOT NULL,

    destino_lat DECIMAL(10,7) NOT NULL,
    destino_lng DECIMAL(10,7) NOT NULL,
    destino_direccion VARCHAR(255) NOT NULL,

    importe_estimado DECIMAL(10,2) NOT NULL,
    importe_final DECIMAL(10,2) NOT NULL,
    distancia_km DECIMAL(8,2) DEFAULT NULL,
    duracion_min DECIMAL(8,2) DEFAULT NULL,

    CONSTRAINT fk_viaje_rider
        FOREIGN KEY (id_rider) REFERENCES rider(id_usuario)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_viaje_driver
        FOREIGN KEY (id_driver_asignado) REFERENCES driver(id_usuario)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT chk_viaje_importes CHECK (importe_estimado >= 0 AND importe_final >= 0),
    CONSTRAINT chk_viaje_distancia CHECK (distancia_km IS NULL OR distancia_km >= 0),
    CONSTRAINT chk_viaje_duracion CHECK (duracion_min IS NULL OR duracion_min >= 0),
    CONSTRAINT chk_viaje_fechas CHECK (
        fecha_aceptacion IS NULL OR fecha_aceptacion >= fecha_solicitud
    )
) ENGINE=InnoDB;

-- =========================================
-- TABLA: OFERTA
-- Un viaje puede generar varias ofertas a conductores
-- =========================================
CREATE TABLE oferta (
    id_oferta BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_viaje BIGINT NOT NULL,
    id_driver BIGINT NOT NULL,
    fecha_envio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado_oferta VARCHAR(30) NOT NULL,
    fecha_respuesta DATETIME DEFAULT NULL,

    CONSTRAINT fk_oferta_viaje
        FOREIGN KEY (id_viaje) REFERENCES viaje(id_viaje)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_oferta_driver
        FOREIGN KEY (id_driver) REFERENCES driver(id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT chk_oferta_fechas CHECK (
        fecha_respuesta IS NULL OR fecha_respuesta >= fecha_envio
    )
) ENGINE=InnoDB;

-- =========================================
-- TABLA: AJUSTE_TARIFA
-- Guarda modificaciones sobre la tarifa del viaje
-- =========================================
CREATE TABLE ajuste_tarifa (
    id_ajuste BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_viaje BIGINT NOT NULL,
    motivo VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255),
    importe_ajuste DECIMAL(10,2) NOT NULL,
    fecha_ajuste DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_ajuste_viaje
        FOREIGN KEY (id_viaje) REFERENCES viaje(id_viaje)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =========================================
-- AUDITORIA_EVENTO
-- Auditoría genérica del sistema
-- =========================================
CREATE TABLE auditoria_evento (
    id_auditoria BIGINT PRIMARY KEY AUTO_INCREMENT,
    tabla_afectada VARCHAR(50) NOT NULL,
    id_registro BIGINT NOT NULL,
    accion VARCHAR(20) NOT NULL,
    detalle VARCHAR(255),
    usuario_bd VARCHAR(100) NOT NULL,
    fecha_evento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;