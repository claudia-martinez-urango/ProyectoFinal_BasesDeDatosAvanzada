USE ride_hailing;


-- *****************************************************
-- 1. CONSULTAS BÁSICAS DE OPERATIVA
-- *****************************************************

-- Ver todos los viajes con rider y driver asignado
SELECT
    v.id_viaje,
    v.estado,
    v.fecha_solicitud,
    CONCAT(ur.nombre, ' ', ur.apellidos) AS rider,
    CONCAT(ud.nombre, ' ', ud.apellidos) AS driver,
    v.origen_direccion,
    v.destino_direccion,
    v.importe_estimado,
    v.importe_final
FROM viaje v
JOIN rider r ON v.id_rider = r.id_usuario
JOIN usuario ur ON r.id_usuario = ur.id_usuario
LEFT JOIN driver d ON v.id_driver_asignado = d.id_usuario
LEFT JOIN usuario ud ON d.id_usuario = ud.id_usuario
ORDER BY v.id_viaje;

-- Ver ofertas de un viaje concreto
SELECT
    o.id_oferta,
    o.id_viaje,
    o.estado_oferta,
    o.fecha_envio,
    o.fecha_respuesta,
    CONCAT(u.nombre, ' ', u.apellidos) AS driver
FROM oferta o
JOIN driver d ON o.id_driver = d.id_usuario
JOIN usuario u ON d.id_usuario = u.id_usuario
WHERE o.id_viaje = 1
ORDER BY o.fecha_envio;

-- Ver ajustes de tarifa de un viaje
SELECT
    a.id_ajuste,
    a.id_viaje,
    a.motivo,
    a.descripcion,
    a.importe_ajuste,
    a.fecha_ajuste
FROM ajuste_tarifa a
WHERE a.id_viaje = 1
ORDER BY a.fecha_ajuste;

-- Ver vehículos y su conductor actual
SELECT
    vh.id_vehiculo,
    vh.matricula,
    vh.marca,
    vh.modelo,
    vh.color,
    CONCAT(u.nombre, ' ', u.apellidos) AS driver,
    dv.fecha_desde,
    dv.fecha_hasta
FROM driver_vehiculo dv
JOIN vehiculo vh ON dv.id_vehiculo = vh.id_vehiculo
JOIN driver d ON dv.id_usuario_driver = d.id_usuario
JOIN usuario u ON d.id_usuario = u.id_usuario
ORDER BY vh.id_vehiculo, dv.fecha_desde;

-- Ver viajes finalizados de un rider
SELECT
    v.id_viaje,
    v.estado,
    v.fecha_inicio,
    v.fecha_fin,
    v.origen_direccion,
    v.destino_direccion,
    v.importe_final
FROM viaje v
WHERE v.id_rider = 7
  AND v.estado = 'FINALIZADO'
ORDER BY v.fecha_inicio DESC;


-- ******************************************************
-- 2. INSERTS OPERATIVOS
-- ******************************************************

-- Insertar un nuevo usuario
INSERT INTO usuario (nombre, apellidos, email, telefono, activo)
VALUES ('Mario', 'Serrano Ruiz', 'mario.serrano@email.com', '602111111', TRUE);

-- Convertir ese usuario en rider
-- (suponiendo que el id generado es el último insertado)
INSERT INTO rider (id_usuario)
VALUES (LAST_INSERT_ID());

-- Insertar un nuevo vehículo
INSERT INTO vehiculo (matricula, marca, modelo, color, plazas, anio, activo)
VALUES ('4455XYZ', 'Skoda', 'Octavia', 'Gris', 4, 2022, TRUE);

-- Insertar un nuevo viaje solicitado
INSERT INTO viaje (
    id_rider,
    id_driver_asignado,
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
    8,
    NULL,
    'SOLICITADO',
    NOW(),
    40.4167750,
    -3.7037900,
    'Puerta del Sol, Madrid',
    40.4296000,
    -3.6987000,
    'Alonso Martinez, Madrid',
    9.50,
    9.50
);

-- Enviar oferta a varios conductores para ese viaje
INSERT INTO oferta (id_viaje, id_driver, fecha_envio, estado_oferta)
VALUES
(LAST_INSERT_ID(), 1, NOW(), 'PENDIENTE'),
(LAST_INSERT_ID(), 2, NOW(), 'PENDIENTE'),
(LAST_INSERT_ID(), 3, NOW(), 'PENDIENTE');


-- *****************************************************
-- 3. UPDATES OPERATIVOS
-- *****************************************************

-- Marcar un viaje como aceptado
UPDATE viaje
SET estado = 'ACEPTADO',
    fecha_aceptacion = NOW(),
    id_driver_asignado = 1
WHERE id_viaje = 5
  AND estado = 'SOLICITADO';

-- Marcar un viaje como en curso
UPDATE viaje
SET estado = 'EN_CURSO',
    fecha_inicio = NOW()
WHERE id_viaje = 5
  AND estado = 'ACEPTADO';

-- Marcar un viaje como finalizado
UPDATE viaje
SET estado = 'FINALIZADO',
    fecha_fin = NOW(),
    distancia_km = 7.80,
    duracion_min = 18.00
WHERE id_viaje = 5
  AND estado = 'EN_CURSO';

-- Añadir un ajuste de tarifa
INSERT INTO ajuste_tarifa (id_viaje, motivo, descripcion, importe_ajuste, fecha_ajuste)
VALUES (5, 'TIEMPO_ESPERA', 'Espera de 4 minutos', 1.50, NOW());

-- Recalcular importe_final de un viaje
UPDATE viaje v
SET v.importe_final = v.importe_estimado + COALESCE((
    SELECT SUM(a.importe_ajuste)
    FROM ajuste_tarifa a
    WHERE a.id_viaje = v.id_viaje
), 0)
WHERE v.id_viaje = 5;

-- Actualizar estado de una oferta
UPDATE oferta
SET estado_oferta = 'RECHAZADA',
    fecha_respuesta = NOW()
WHERE id_oferta = 2
  AND estado_oferta = 'PENDIENTE';


-- ******************************************************
-- 4. DELETE OPERATIVO
-- ******************************************************

-- Borrar un ajuste de tarifa concreto
DELETE FROM ajuste_tarifa
WHERE id_ajuste = 3;

-- Cancelar lógicamente un usuario en vez de borrarlo físicamente
UPDATE usuario
SET activo = FALSE
WHERE id_usuario = 15;


-- ******************************************************
-- 5. JOINS ÚTILES
-- ******************************************************

-- Viajes con company del conductor
SELECT
    v.id_viaje,
    v.estado,
    CONCAT(ud.nombre, ' ', ud.apellidos) AS driver,
    c.nombre AS company,
    v.importe_final
FROM viaje v
LEFT JOIN driver d ON v.id_driver_asignado = d.id_usuario
LEFT JOIN usuario ud ON d.id_usuario = ud.id_usuario
LEFT JOIN company c ON d.id_company = c.id_company
ORDER BY v.id_viaje;

-- Ofertas con company y decisión tomada
SELECT
    o.id_oferta,
    o.id_viaje,
    CONCAT(u.nombre, ' ', u.apellidos) AS driver,
    c.nombre AS company,
    o.estado_oferta,
    o.fecha_envio,
    o.fecha_respuesta
FROM oferta o
JOIN driver d ON o.id_driver = d.id_usuario
JOIN usuario u ON d.id_usuario = u.id_usuario
JOIN company c ON d.id_company = c.id_company
ORDER BY o.id_viaje, o.id_oferta;

-- Ingresos por conductor
SELECT
    d.id_usuario AS id_driver,
    CONCAT(u.nombre, ' ', u.apellidos) AS driver,
    COUNT(v.id_viaje) AS total_viajes,
    SUM(v.importe_final) AS ingresos_totales
FROM driver d
JOIN usuario u ON d.id_usuario = u.id_usuario
LEFT JOIN viaje v
    ON v.id_driver_asignado = d.id_usuario
   AND v.estado = 'FINALIZADO'
GROUP BY d.id_usuario, u.nombre, u.apellidos
ORDER BY ingresos_totales DESC;


-- ******************************************************
-- 6. TRANSACCIONES
-- ******************************************************

-- Transacción: crear viaje y generar ofertas
START TRANSACTION;

INSERT INTO viaje (
    id_rider,
    id_driver_asignado,
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
    9,
    NULL,
    'SOLICITADO',
    NOW(),
    40.4200000,
    -3.7050000,
    'Callao, Madrid',
    40.4500000,
    -3.6900000,
    'Santiago Bernabeu, Madrid',
    11.00,
    11.00
);

SET @nuevo_viaje = LAST_INSERT_ID();

INSERT INTO oferta (id_viaje, id_driver, fecha_envio, estado_oferta)
VALUES
(@nuevo_viaje, 1, NOW(), 'PENDIENTE'),
(@nuevo_viaje, 2, NOW(), 'PENDIENTE'),
(@nuevo_viaje, 4, NOW(), 'PENDIENTE');

COMMIT;


-- Transacción: finalizar viaje + ajuste + recálculo de importe
START TRANSACTION;

UPDATE viaje
SET estado = 'FINALIZADO',
    fecha_fin = NOW(),
    distancia_km = 10.20,
    duracion_min = 24.00
WHERE id_viaje = 9
  AND estado = 'EN_CURSO';

INSERT INTO ajuste_tarifa (id_viaje, motivo, descripcion, importe_ajuste, fecha_ajuste)
VALUES (9, 'PEAJE', 'Peaje durante el trayecto', 2.00, NOW());

UPDATE viaje v
SET v.importe_final = v.importe_estimado + COALESCE((
    SELECT SUM(a.importe_ajuste)
    FROM ajuste_tarifa a
    WHERE a.id_viaje = v.id_viaje
), 0)
WHERE v.id_viaje = 9;

COMMIT;


-- ******************************************************
-- 7. LOCK POR CONCURRENCIA
-- Primer conductor que acepta se queda el viaje
-- ******************************************************

-- EJEMPLO:
-- Esta transacción bloquea la fila del viaje antes de aceptar,
-- evitando que dos conductores acepten a la vez el mismo viaje.

START TRANSACTION;

-- Bloqueamos el viaje
SELECT id_viaje, estado, id_driver_asignado
FROM viaje
WHERE id_viaje = 3
FOR UPDATE;

-- Solo si sigue sin conductor asignado y en estado solicitado/pediente de aceptación:
UPDATE viaje
SET id_driver_asignado = 2,
    estado = 'ACEPTADO',
    fecha_aceptacion = NOW()
WHERE id_viaje = 3
  AND id_driver_asignado IS NULL
  AND estado IN ('SOLICITADO', 'PENDIENTE');

-- Marcar la oferta del conductor ganador como aceptada
UPDATE oferta
SET estado_oferta = 'ACEPTADA',
    fecha_respuesta = NOW()
WHERE id_viaje = 3
  AND id_driver = 2
  AND estado_oferta = 'PENDIENTE';

-- Marcar el resto como rechazadas automáticamente
UPDATE oferta
SET estado_oferta = 'RECHAZADA',
    fecha_respuesta = NOW()
WHERE id_viaje = 3
  AND id_driver <> 2
  AND estado_oferta = 'PENDIENTE';

COMMIT;


-- *****************************************************
-- 8. AUDITORÍA BÁSICA MANUAL
-- *****************************************************

INSERT INTO auditoria_evento (tabla_afectada, id_registro, accion, detalle, usuario_bd, fecha_evento)
VALUES ('viaje', 3, 'UPDATE', 'Viaje aceptado por conductor 2', CURRENT_USER(), NOW());

INSERT INTO auditoria_evento (tabla_afectada, id_registro, accion, detalle, usuario_bd, fecha_evento)
VALUES ('oferta', 3, 'UPDATE', 'Oferta aceptada en proceso de asignacion', CURRENT_USER(), NOW());


-- ******************************************************
-- 9. CONSULTAS DE COMPROBACIÓN FINAL
-- ******************************************************

SELECT * FROM viaje ORDER BY id_viaje;
SELECT * FROM oferta ORDER BY id_oferta;
SELECT * FROM ajuste_tarifa ORDER BY id_ajuste;
SELECT * FROM auditoria_evento ORDER BY id_auditoria;