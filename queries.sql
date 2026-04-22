USE ride_hailing;

-- Viajes con rider, driver y método de pago
SELECT
    v.id_viaje,
    v.estado,
    v.fecha_solicitud,
    CONCAT(ur.nombre, ' ', ur.apellidos) AS rider,
    CONCAT(ud.nombre, ' ', ud.apellidos) AS driver,
    mp.tipo AS metodo_pago,
    mp.detalle,
    v.origen_direccion,
    v.destino_direccion,
    v.importe_estimado,
    v.importe_final
FROM viaje v
JOIN rider r ON v.id_rider = r.id_usuario
JOIN usuario ur ON r.id_usuario = ur.id_usuario
LEFT JOIN driver d ON v.id_driver_asignado = d.id_usuario
LEFT JOIN usuario ud ON d.id_usuario = ud.id_usuario
JOIN metodo_pago mp ON v.id_metodo_pago = mp.id_metodo_pago
ORDER BY v.id_viaje;

-- Ofertas de un viaje concreto
SELECT
    o.id_oferta,
    o.id_viaje,
    o.estado_oferta,
    o.fecha_envio,
    o.fecha_respuesta,
    CONCAT(u.nombre, ' ', u.apellidos) AS driver,
    c.nombre AS company
FROM oferta o
JOIN driver d ON o.id_driver = d.id_usuario
JOIN usuario u ON d.id_usuario = u.id_usuario
JOIN company c ON d.id_company = c.id_company
WHERE o.id_viaje = 1
ORDER BY o.fecha_envio;

-- Ajustes de tarifa con tipo normalizado
SELECT
    a.id_ajuste,
    a.id_viaje,
    t.codigo,
    t.nombre,
    a.descripcion,
    a.importe_ajuste,
    a.fecha_ajuste
FROM ajuste_tarifa a
JOIN tipo_ajuste_tarifa t ON a.id_tipo_ajuste = t.id_tipo_ajuste
WHERE a.id_viaje = 1
ORDER BY a.fecha_ajuste;

-- Incidencias de un viaje
SELECT
    i.id_incidencia,
    i.tipo_incidencia,
    i.descripcion,
    i.estado_incidencia,
    CONCAT(u.nombre, ' ', u.apellidos) AS reportada_por,
    i.fecha_reporte,
    i.fecha_resolucion
FROM incidencia i
JOIN usuario u ON i.id_usuario_reporta = u.id_usuario
WHERE i.id_viaje = 14
ORDER BY i.fecha_reporte;

-- Calificaciones de un conductor
SELECT
    c.id_calificacion,
    c.id_viaje,
    CONCAT(ue.nombre, ' ', ue.apellidos) AS emisor,
    CONCAT(ur.nombre, ' ', ur.apellidos) AS receptor,
    c.puntuacion,
    c.comentario,
    c.fecha_calificacion
FROM calificacion c
JOIN usuario ue ON c.id_emisor = ue.id_usuario
JOIN usuario ur ON c.id_receptor = ur.id_usuario
WHERE c.id_receptor = 2
ORDER BY c.fecha_calificacion DESC;

-- Media de puntuación por conductor
SELECT
    d.id_usuario AS id_driver,
    CONCAT(u.nombre, ' ', u.apellidos) AS driver,
    ROUND(AVG(c.puntuacion), 2) AS media_puntuacion,
    COUNT(c.id_calificacion) AS total_valoraciones
FROM driver d
JOIN usuario u ON d.id_usuario = u.id_usuario
LEFT JOIN calificacion c
    ON d.id_usuario = c.id_receptor
   AND c.rol_receptor = 'DRIVER'
GROUP BY d.id_usuario, u.nombre, u.apellidos
ORDER BY media_puntuacion DESC;

-- Insertar nuevo usuario
INSERT INTO usuario (nombre, apellidos, email, telefono, activo)
VALUES ('Irene', 'Molina Vega', 'irene.molina@email.com', '603111111', TRUE);

-- Convertirlo en rider
INSERT INTO rider (id_usuario)
VALUES (LAST_INSERT_ID());

-- Añadir método de pago al nuevo usuario
INSERT INTO metodo_pago (id_usuario, tipo, detalle, activo)
VALUES (LAST_INSERT_ID(), 'TARJETA', 'Visa **** 5454', TRUE);

-- Insertar un viaje nuevo
INSERT INTO viaje (
    id_rider,
    id_driver_asignado,
    id_metodo_pago,
    estado,
    fecha_solicitud,
    origen_lat,
    origen_lng,
    origen_direccion,
    destino_lat,
    destino_lng,
    destino_direccion,
    importe_estimado,
    importe_final
) VALUES (
    16,
    NULL,
    12,
    'SOLICITADO',
    NOW(),
    40.4167750,
    -3.7037900,
    'Puerta del Sol, Madrid',
    40.4300000,
    -3.7000000,
    'Bilbao, Madrid',
    9.80,
    9.80
);

-- Enviar ofertas a varios conductores
INSERT INTO oferta (id_viaje, id_driver, fecha_envio, estado_oferta)
VALUES
(LAST_INSERT_ID(), 1, NOW(), 'PENDIENTE'),
(LAST_INSERT_ID(), 2, NOW(), 'PENDIENTE'),
(LAST_INSERT_ID(), 4, NOW(), 'PENDIENTE');

-- Añadir una incidencia
INSERT INTO incidencia (
    id_viaje,
    id_usuario_reporta,
    tipo_incidencia,
    descripcion,
    estado_incidencia,
    fecha_reporte
) VALUES (
    14,
    11,
    'RETRASO',
    'El conductor tardó más de lo esperado en llegar',
    'ABIERTA',
    NOW()
);

-- Añadir una calificación del rider al driver
INSERT INTO calificacion (
    id_viaje,
    id_emisor,
    id_receptor,
    rol_emisor,
    rol_receptor,
    puntuacion,
    comentario,
    fecha_calificacion
) VALUES (
    14,
    11,
    6,
    'RIDER',
    'DRIVER',
    4,
    'Buen trato, aunque hubo algo de retraso',
    NOW()
);

-- Añadir un ajuste de tarifa
INSERT INTO ajuste_tarifa (
    id_viaje,
    id_tipo_ajuste,
    descripcion,
    importe_ajuste,
    fecha_ajuste
) VALUES (
    13,
    3,
    'Peaje añadido al final del trayecto',
    1.80,
    NOW()
);

-- Recalcular importe final de un viaje
UPDATE viaje v
SET v.importe_final = v.importe_estimado + COALESCE((
    SELECT SUM(a.importe_ajuste)
    FROM ajuste_tarifa a
    WHERE a.id_viaje = v.id_viaje
), 0)
WHERE v.id_viaje = 13;

-- Cambiar una incidencia a resuelta
UPDATE incidencia
SET estado_incidencia = 'RESUELTA',
    fecha_resolucion = NOW()
WHERE id_incidencia = 5
  AND estado_incidencia = 'EN_REVISION';

-- Desactivar método de pago
UPDATE metodo_pago
SET activo = FALSE
WHERE id_metodo_pago = 13;

-- Borrado de una incidencia cerrada
DELETE FROM incidencia
WHERE id_incidencia = 2
  AND estado_incidencia = 'CERRADA';

-- Join de viajes con company y método de pago
SELECT
    v.id_viaje,
    v.estado,
    CONCAT(ur.nombre, ' ', ur.apellidos) AS rider,
    CONCAT(ud.nombre, ' ', ud.apellidos) AS driver,
    c.nombre AS company,
    mp.tipo AS metodo_pago,
    v.importe_final
FROM viaje v
JOIN usuario ur ON v.id_rider = ur.id_usuario
LEFT JOIN driver d ON v.id_driver_asignado = d.id_usuario
LEFT JOIN usuario ud ON d.id_usuario = ud.id_usuario
LEFT JOIN company c ON d.id_company = c.id_company
JOIN metodo_pago mp ON v.id_metodo_pago = mp.id_metodo_pago
ORDER BY v.id_viaje;

-- Transacción: crear viaje y ofertas
START TRANSACTION;

INSERT INTO viaje (
    id_rider,
    id_driver_asignado,
    id_metodo_pago,
    estado,
    fecha_solicitud,
    origen_lat,
    origen_lng,
    origen_direccion,
    destino_lat,
    destino_lng,
    destino_direccion,
    importe_estimado,
    importe_final
) VALUES (
    17,
    NULL,
    14,
    'SOLICITADO',
    NOW(),
    40.4250000,
    -3.7020000,
    'Chueca, Madrid',
    40.4705000,
    -3.6885000,
    'Cuzco, Madrid',
    12.40,
    12.40
);

SET @nuevo_viaje = LAST_INSERT_ID();

INSERT INTO oferta (id_viaje, id_driver, fecha_envio, estado_oferta)
VALUES
(@nuevo_viaje, 1, NOW(), 'PENDIENTE'),
(@nuevo_viaje, 2, NOW(), 'PENDIENTE'),
(@nuevo_viaje, 6, NOW(), 'PENDIENTE');

COMMIT;

-- Transacción: finalizar viaje, añadir ajuste y registrar calificación
START TRANSACTION;

UPDATE viaje
SET estado = 'FINALIZADO',
    fecha_fin = NOW(),
    distancia_km = 7.90,
    duracion_min = 19.00
WHERE id_viaje = 9
  AND estado = 'EN_CURSO';

INSERT INTO ajuste_tarifa (id_viaje, id_tipo_ajuste, descripcion, importe_ajuste, fecha_ajuste)
VALUES (9, 4, 'Suplemento por alta demanda', 1.50, NOW());

UPDATE viaje v
SET v.importe_final = v.importe_estimado + COALESCE((
    SELECT SUM(a.importe_ajuste)
    FROM ajuste_tarifa a
    WHERE a.id_viaje = v.id_viaje
), 0)
WHERE v.id_viaje = 9;

INSERT INTO calificacion (
    id_viaje, id_emisor, id_receptor, rol_emisor, rol_receptor,
    puntuacion, comentario, fecha_calificacion
) VALUES (
    9, 15, 3, 'RIDER', 'DRIVER', 5, 'Trayecto muy cómodo', NOW()
);

COMMIT;

-- Concurrencia: primer conductor que acepta se queda el viaje
START TRANSACTION;

SELECT id_viaje, estado, id_driver_asignado
FROM viaje
WHERE id_viaje = 5
FOR UPDATE;

UPDATE viaje
SET id_driver_asignado = 2,
    estado = 'ACEPTADO',
    fecha_aceptacion = NOW()
WHERE id_viaje = 5
  AND id_driver_asignado IS NULL
  AND estado = 'SOLICITADO';

UPDATE oferta
SET estado_oferta = 'ACEPTADA',
    fecha_respuesta = NOW()
WHERE id_viaje = 5
  AND id_driver = 2
  AND estado_oferta = 'PENDIENTE';

UPDATE oferta
SET estado_oferta = 'RECHAZADA',
    fecha_respuesta = NOW()
WHERE id_viaje = 5
  AND id_driver <> 2
  AND estado_oferta = 'PENDIENTE';

COMMIT;

-- Auditoría manual
INSERT INTO auditoria_evento (tabla_afectada, id_registro, accion, detalle, usuario_bd, fecha_evento)
VALUES ('viaje', 5, 'UPDATE', 'Viaje aceptado por conductor 2', CURRENT_USER(), NOW());

INSERT INTO auditoria_evento (tabla_afectada, id_registro, accion, detalle, usuario_bd, fecha_evento)
VALUES ('incidencia', 5, 'UPDATE', 'Incidencia marcada como resuelta', CURRENT_USER(), NOW());

-- Comprobación final
SELECT * FROM viaje ORDER BY id_viaje;
SELECT * FROM oferta ORDER BY id_oferta;
SELECT * FROM ajuste_tarifa ORDER BY id_ajuste;
SELECT * FROM calificacion ORDER BY id_calificacion;
SELECT * FROM incidencia ORDER BY id_incidencia;
SELECT * FROM auditoria_evento ORDER BY id_auditoria;