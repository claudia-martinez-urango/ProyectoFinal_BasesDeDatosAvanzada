DROP DATABASE IF EXISTS ride_hailing;
CREATE DATABASE ride_hailing;
USE ride_hailing;

-- COMPANY
CREATE TABLE company (
    id_company BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    cif VARCHAR(20) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    email VARCHAR(120),
    activa BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB;

-- USUARIO
CREATE TABLE usuario (
    id_usuario BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(80) NOT NULL,
    apellidos VARCHAR(120) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    fecha_alta DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB;

-- DRIVER
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

-- RIDER
CREATE TABLE rider (
    id_usuario BIGINT PRIMARY KEY,
    CONSTRAINT fk_rider_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- METODO_PAGO
CREATE TABLE metodo_pago (
    id_metodo_pago BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_usuario BIGINT NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    detalle VARCHAR(100),
    activo BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_metodo_pago_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT chk_metodo_pago_tipo CHECK (
        tipo IN ('TARJETA', 'PAYPAL', 'EFECTIVO', 'BIZUM')
    )
) ENGINE=InnoDB;

-- VEHICULO
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

-- DRIVER_VEHICULO
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

-- VIAJE
CREATE TABLE viaje (
    id_viaje BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_rider BIGINT NOT NULL,
    id_driver_asignado BIGINT DEFAULT NULL,
    id_metodo_pago BIGINT NOT NULL,
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
    CONSTRAINT fk_viaje_metodo_pago
        FOREIGN KEY (id_metodo_pago) REFERENCES metodo_pago(id_metodo_pago)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT chk_viaje_importes CHECK (importe_estimado >= 0 AND importe_final >= 0),
    CONSTRAINT chk_viaje_distancia CHECK (distancia_km IS NULL OR distancia_km >= 0),
    CONSTRAINT chk_viaje_duracion CHECK (duracion_min IS NULL OR duracion_min >= 0),
    CONSTRAINT chk_viaje_fechas CHECK (
        fecha_aceptacion IS NULL OR fecha_aceptacion >= fecha_solicitud
    )
) ENGINE=InnoDB;

-- OFERTA
CREATE TABLE oferta (
    id_oferta BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_viaje BIGINT NOT NULL,
    id_driver BIGINT NOT NULL,
    id_viaje_aceptado BIGINT DEFAULT NULL,
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

-- TIPO_AJUSTE_TARIFA
CREATE TABLE tipo_ajuste_tarifa (
    id_tipo_ajuste BIGINT PRIMARY KEY AUTO_INCREMENT,
    codigo VARCHAR(50) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255)
) ENGINE=InnoDB;

-- AJUSTE_TARIFA
CREATE TABLE ajuste_tarifa (
    id_ajuste BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_viaje BIGINT NOT NULL,
    id_tipo_ajuste BIGINT NOT NULL,
    descripcion VARCHAR(255),
    importe_ajuste DECIMAL(10,2) NOT NULL,
    fecha_ajuste DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_ajuste_viaje
        FOREIGN KEY (id_viaje) REFERENCES viaje(id_viaje)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_ajuste_tipo
        FOREIGN KEY (id_tipo_ajuste) REFERENCES tipo_ajuste_tarifa(id_tipo_ajuste)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- CALIFICACION
CREATE TABLE calificacion (
    id_calificacion BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_viaje BIGINT NOT NULL,
    id_emisor BIGINT NOT NULL,
    id_receptor BIGINT NOT NULL,
    rol_emisor VARCHAR(20) NOT NULL,
    rol_receptor VARCHAR(20) NOT NULL,
    puntuacion INT NOT NULL,
    comentario VARCHAR(255),
    fecha_calificacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_calificacion_viaje
        FOREIGN KEY (id_viaje) REFERENCES viaje(id_viaje)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_calificacion_emisor
        FOREIGN KEY (id_emisor) REFERENCES usuario(id_usuario)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_calificacion_receptor
        FOREIGN KEY (id_receptor) REFERENCES usuario(id_usuario)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT chk_calificacion_puntuacion CHECK (puntuacion BETWEEN 1 AND 5),
    CONSTRAINT chk_calificacion_roles CHECK (
        rol_emisor IN ('RIDER', 'DRIVER') AND
        rol_receptor IN ('RIDER', 'DRIVER') AND
        rol_emisor <> rol_receptor
    )
) ENGINE=InnoDB;

-- INCIDENCIA
CREATE TABLE incidencia (
    id_incidencia BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_viaje BIGINT NOT NULL,
    id_usuario_reporta BIGINT NOT NULL,
    tipo_incidencia VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    estado_incidencia VARCHAR(30) NOT NULL,
    fecha_reporte DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_resolucion DATETIME DEFAULT NULL,

    CONSTRAINT fk_incidencia_viaje
        FOREIGN KEY (id_viaje) REFERENCES viaje(id_viaje)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_incidencia_usuario
        FOREIGN KEY (id_usuario_reporta) REFERENCES usuario(id_usuario)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT chk_incidencia_estado CHECK (
        estado_incidencia IN ('ABIERTA', 'EN_REVISION', 'RESUELTA', 'CERRADA')
    ),
    CONSTRAINT chk_incidencia_fechas CHECK (
        fecha_resolucion IS NULL OR fecha_resolucion >= fecha_reporte
    )
) ENGINE=InnoDB;

-- AUDITORIA_EVENTO
CREATE TABLE auditoria_evento (
    id_auditoria BIGINT PRIMARY KEY AUTO_INCREMENT,
    tabla_afectada VARCHAR(50) NOT NULL,
    id_registro BIGINT NOT NULL,
    accion VARCHAR(20) NOT NULL,
    detalle VARCHAR(255),
    usuario_bd VARCHAR(100) NOT NULL,
    fecha_evento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ***********************************************************************************
-- ÍNDICES
CREATE INDEX idx_metodo_pago_usuario ON metodo_pago(id_usuario);

CREATE INDEX idx_viaje_rider ON viaje(id_rider);
CREATE INDEX idx_viaje_driver ON viaje(id_driver_asignado);
CREATE INDEX idx_viaje_metodo_pago ON viaje(id_metodo_pago);
CREATE INDEX idx_viaje_estado ON viaje(estado);

CREATE INDEX idx_oferta_viaje ON oferta(id_viaje);
CREATE INDEX idx_oferta_driver ON oferta(id_driver);
CREATE INDEX idx_oferta_estado ON oferta(estado_oferta);

-- Evita que un mismo viaje tenga más de una oferta aceptada.
-- Solo las ofertas ACEPTADA rellenan id_viaje_aceptado.
-- Las ofertas PENDIENTE o RECHAZADA quedan con NULL y no chocan en el índice único.
CREATE UNIQUE INDEX uq_oferta_aceptada_por_viaje
ON oferta(id_viaje_aceptado);

CREATE INDEX idx_ajuste_viaje ON ajuste_tarifa(id_viaje);
CREATE INDEX idx_ajuste_tipo ON ajuste_tarifa(id_tipo_ajuste);

CREATE INDEX idx_calificacion_viaje ON calificacion(id_viaje);
CREATE INDEX idx_calificacion_emisor ON calificacion(id_emisor);
CREATE INDEX idx_calificacion_receptor ON calificacion(id_receptor);

CREATE INDEX idx_incidencia_viaje ON incidencia(id_viaje);
CREATE INDEX idx_incidencia_usuario ON incidencia(id_usuario_reporta);
CREATE INDEX idx_incidencia_estado ON incidencia(estado_incidencia);


-- ***********************************************************************************
-- TRIGGERS

DELIMITER //

CREATE TRIGGER trg_oferta_bi_set_id_viaje_aceptado
BEFORE INSERT ON oferta
FOR EACH ROW
BEGIN
    IF NEW.estado_oferta = 'ACEPTADA' THEN
        SET NEW.id_viaje_aceptado = NEW.id_viaje;
    ELSE
        SET NEW.id_viaje_aceptado = NULL;
    END IF;
END//

CREATE TRIGGER trg_oferta_bu_set_id_viaje_aceptado
BEFORE UPDATE ON oferta
FOR EACH ROW
BEGIN
    IF NEW.estado_oferta = 'ACEPTADA' THEN
        SET NEW.id_viaje_aceptado = NEW.id_viaje;
    ELSE
        SET NEW.id_viaje_aceptado = NULL;
    END IF;
END//

DELIMITER ;