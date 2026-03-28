USE ride_hailing;

-- =========================================
-- COMPANY
-- =========================================
INSERT INTO company (nombre, cif, telefono, email, activa) VALUES
('MoveFast Mobility', 'A12345678', '911111111', 'contacto@movefast.com', TRUE),
('UrbanGo Transport', 'B87654321', '922222222', 'info@urbango.com', TRUE),
('CityRide Partners', 'C11223344', '933333333', 'support@cityride.com', TRUE),
('BlueCab Services', 'D55667788', '944444444', 'hello@bluecab.com', TRUE);

-- =========================================
-- USUARIO
-- 1-6 drivers
-- 7-15 riders
-- =========================================
INSERT INTO usuario (nombre, apellidos, email, telefono, fecha_alta, activo) VALUES
('Carlos', 'Lopez Garcia', 'carlos.lopez@email.com', '600111111', '2026-01-10 09:00:00', TRUE),
('Marta', 'Sanchez Ruiz', 'marta.sanchez@email.com', '600222222', '2026-01-11 10:00:00', TRUE),
('David', 'Romero Gil', 'david.romero@email.com', '600333333', '2026-01-12 11:00:00', TRUE),
('Elena', 'Navarro Perez', 'elena.navarro@email.com', '600444444', '2026-01-13 12:00:00', TRUE),
('Jorge', 'Martin Leon', 'jorge.martin@email.com', '600555555', '2026-01-14 13:00:00', TRUE),
('Paula', 'Diaz Moreno', 'paula.diaz@email.com', '600666666', '2026-01-15 14:00:00', TRUE),

('Lucia', 'Fernandez Diaz', 'lucia.fernandez@email.com', '600777777', '2026-02-01 09:30:00', TRUE),
('Javier', 'Martin Perez', 'javier.martin@email.com', '600888888', '2026-02-02 09:45:00', TRUE),
('Ana', 'Gomez Torres', 'ana.gomez@email.com', '600999999', '2026-02-03 10:00:00', TRUE),
('Sergio', 'Ruiz Castro', 'sergio.ruiz@email.com', '601111111', '2026-02-04 10:15:00', TRUE),
('Claudia', 'Morales Vega', 'claudia.morales@email.com', '601222222', '2026-02-05 10:30:00', TRUE),
('Pablo', 'Herrera Navas', 'pablo.herrera@email.com', '601333333', '2026-02-06 10:45:00', TRUE),
('Laura', 'Iglesias Soto', 'laura.iglesias@email.com', '601444444', '2026-02-07 11:00:00', TRUE),
('Raul', 'Prieto Mena', 'raul.prieto@email.com', '601555555', '2026-02-08 11:15:00', TRUE),
('Nuria', 'Calvo Reyes', 'nuria.calvo@email.com', '601666666', '2026-02-09 11:30:00', TRUE);

-- =========================================
-- DRIVER
-- =========================================
INSERT INTO driver (id_usuario, id_company, num_licencia, estado_driver, fecha_alta_driver) VALUES
(1, 1, 'LIC-0001', 'ACTIVO', '2026-01-10 09:30:00'),
(2, 2, 'LIC-0002', 'ACTIVO', '2026-01-11 10:30:00'),
(3, 1, 'LIC-0003', 'ACTIVO', '2026-01-12 11:30:00'),
(4, 3, 'LIC-0004', 'ACTIVO', '2026-01-13 12:30:00'),
(5, 4, 'LIC-0005', 'INACTIVO', '2026-01-14 13:30:00'),
(6, 2, 'LIC-0006', 'ACTIVO', '2026-01-15 14:30:00');

-- =========================================
-- RIDER
-- =========================================
INSERT INTO rider (id_usuario) VALUES
(7),(8),(9),(10),(11),(12),(13),(14),(15);

-- =========================================
-- VEHICULO
-- =========================================
INSERT INTO vehiculo (matricula, marca, modelo, color, plazas, anio, activo) VALUES
('1234ABC', 'Toyota', 'Corolla', 'Blanco', 4, 2022, TRUE),
('5678DEF', 'Seat', 'Leon', 'Negro', 4, 2021, TRUE),
('9012GHI', 'Tesla', 'Model 3', 'Rojo', 4, 2023, TRUE),
('3456JKL', 'Hyundai', 'Ioniq', 'Azul', 4, 2022, TRUE),
('7890MNO', 'Kia', 'Niro', 'Gris', 4, 2021, TRUE),
('1122PQR', 'Renault', 'Megane', 'Blanco', 4, 2020, TRUE),
('3344STU', 'Volkswagen', 'Golf', 'Negro', 4, 2022, TRUE);

-- =========================================
-- DRIVER_VEHICULO
-- =========================================
INSERT INTO driver_vehiculo (id_usuario_driver, id_vehiculo, fecha_desde, fecha_hasta) VALUES
(1, 1, '2026-02-01 08:00:00', NULL),
(2, 2, '2026-02-01 08:30:00', NULL),
(3, 3, '2026-02-02 09:00:00', NULL),
(4, 4, '2026-02-02 09:30:00', NULL),
(5, 5, '2026-02-03 10:00:00', '2026-03-01 00:00:00'),
(5, 6, '2026-03-01 00:01:00', NULL),
(6, 7, '2026-02-04 10:30:00', NULL);

-- =========================================
-- VIAJE
-- =========================================
INSERT INTO viaje (
    id_rider, id_driver_asignado, estado,
    fecha_solicitud, fecha_aceptacion, fecha_inicio, fecha_fin,
    origen_lat, origen_lng, origen_direccion,
    destino_lat, destino_lng, destino_direccion,
    importe_estimado, importe_final, distancia_km, duracion_min
) VALUES
(7, 1, 'FINALIZADO',
 '2026-03-10 08:00:00', '2026-03-10 08:01:00', '2026-03-10 08:05:00', '2026-03-10 08:25:00',
 40.4167750, -3.7037900, 'Puerta del Sol, Madrid',
 40.4378698, -3.8196200, 'Ciudad Universitaria, Madrid',
 12.50, 15.00, 8.40, 20.00),

(8, 2, 'FINALIZADO',
 '2026-03-10 09:15:00', '2026-03-10 09:16:00', '2026-03-10 09:20:00', '2026-03-10 09:48:00',
 40.4280000, -3.7040000, 'Gran Via, Madrid',
 40.4893538, -3.6827461, 'Plaza de Castilla, Madrid',
 14.00, 14.00, 9.10, 28.00),

(9, 3, 'FINALIZADO',
 '2026-03-11 11:00:00', '2026-03-11 11:01:00', '2026-03-11 11:04:00', '2026-03-11 11:35:00',
 40.4520000, -3.6880000, 'Santiago Bernabeu, Madrid',
 40.4152600, -3.7074000, 'Plaza Mayor, Madrid',
 13.00, 13.00, 7.80, 31.00),

(10, 4, 'FINALIZADO',
 '2026-03-11 13:30:00', '2026-03-11 13:31:00', '2026-03-11 13:35:00', '2026-03-11 13:55:00',
 40.4700000, -3.7000000, 'Chamartin, Madrid',
 40.4090000, -3.6920000, 'Retiro, Madrid',
 11.50, 12.50, 6.90, 20.00),

(11, NULL, 'PENDIENTE',
 '2026-03-12 18:00:00', NULL, NULL, NULL,
 40.3900000, -3.7200000, 'Atocha, Madrid',
 40.4500000, -3.7000000, 'Chamartin, Madrid',
 10.00, 10.00, NULL, NULL),

(12, 1, 'CANCELADO',
 '2026-03-12 19:10:00', '2026-03-12 19:11:00', NULL, NULL,
 40.4300000, -3.7100000, 'Callao, Madrid',
 40.4200000, -3.6900000, 'Museo del Prado, Madrid',
 8.50, 8.50, NULL, NULL),

(13, 6, 'FINALIZADO',
 '2026-03-13 08:45:00', '2026-03-13 08:46:00', '2026-03-13 08:50:00', '2026-03-13 09:18:00',
 40.4637000, -3.7492000, 'Moncloa, Madrid',
 40.4169000, -3.7033000, 'Sol, Madrid',
 12.00, 13.25, 8.10, 28.00),

(14, 2, 'FINALIZADO',
 '2026-03-13 14:00:00', '2026-03-13 14:02:00', '2026-03-13 14:05:00', '2026-03-13 14:44:00',
 40.4800000, -3.6600000, 'IFEMA, Madrid',
 40.4100000, -3.7000000, 'La Latina, Madrid',
 16.50, 18.00, 11.20, 39.00),

(15, 3, 'EN_CURSO',
 '2026-03-19 17:30:00', '2026-03-19 17:31:00', '2026-03-19 17:36:00', NULL,
 40.4400000, -3.6900000, 'Nuevos Ministerios, Madrid',
 40.4000000, -3.7200000, 'Legazpi, Madrid',
 13.50, 13.50, NULL, NULL),

(7, 4, 'FINALIZADO',
 '2026-03-14 21:00:00', '2026-03-14 21:01:00', '2026-03-14 21:05:00', '2026-03-14 21:42:00',
 40.4180000, -3.7060000, 'Opera, Madrid',
 40.4700000, -3.7200000, 'Aravaca, Madrid',
 17.00, 19.00, 12.60, 37.00);

-- =========================================
-- OFERTA
-- =========================================
INSERT INTO oferta (id_viaje, id_driver, fecha_envio, estado_oferta, fecha_respuesta) VALUES
(1, 1, '2026-03-10 08:00:10', 'ACEPTADA', '2026-03-10 08:01:00'),
(1, 2, '2026-03-10 08:00:10', 'RECHAZADA', '2026-03-10 08:01:20'),

(2, 2, '2026-03-10 09:15:10', 'ACEPTADA', '2026-03-10 09:16:00'),
(2, 3, '2026-03-10 09:15:10', 'RECHAZADA', '2026-03-10 09:16:40'),

(3, 3, '2026-03-11 11:00:10', 'ACEPTADA', '2026-03-11 11:01:00'),
(3, 1, '2026-03-11 11:00:10', 'RECHAZADA', '2026-03-11 11:01:15'),

(4, 4, '2026-03-11 13:30:10', 'ACEPTADA', '2026-03-11 13:31:00'),

(5, 1, '2026-03-12 18:00:10', 'PENDIENTE', NULL),
(5, 2, '2026-03-12 18:00:10', 'PENDIENTE', NULL),
(5, 6, '2026-03-12 18:00:10', 'PENDIENTE', NULL),

(6, 1, '2026-03-12 19:10:10', 'ACEPTADA', '2026-03-12 19:11:00'),

(7, 6, '2026-03-13 08:45:10', 'ACEPTADA', '2026-03-13 08:46:00'),
(7, 4, '2026-03-13 08:45:10', 'RECHAZADA', '2026-03-13 08:46:20'),

(8, 2, '2026-03-13 14:00:10', 'ACEPTADA', '2026-03-13 14:02:00'),
(8, 3, '2026-03-13 14:00:10', 'RECHAZADA', '2026-03-13 14:02:40'),

(9, 3, '2026-03-19 17:30:10', 'ACEPTADA', '2026-03-19 17:31:00'),

(10, 4, '2026-03-14 21:00:10', 'ACEPTADA', '2026-03-14 21:01:00'),
(10, 2, '2026-03-14 21:00:10', 'RECHAZADA', '2026-03-14 21:01:30');

-- =========================================
-- AJUSTE_TARIFA
-- =========================================
INSERT INTO ajuste_tarifa (id_viaje, motivo, descripcion, importe_ajuste, fecha_ajuste) VALUES
(1, 'TIEMPO_ESPERA', 'El conductor esperó 5 minutos adicionales', 1.50, '2026-03-10 08:06:00'),
(1, 'CAMBIO_DESTINO', 'El rider modificó el destino durante el trayecto', 1.00, '2026-03-10 08:12:00'),

(4, 'PEAJE', 'Se aplicó un peaje urbano', 1.00, '2026-03-11 13:40:00'),

(7, 'TIEMPO_ESPERA', 'Espera del conductor en el punto de recogida', 1.25, '2026-03-13 08:52:00'),

(8, 'SUPLEMENTO_DEMANDA', 'Alta demanda en la zona', 1.50, '2026-03-13 14:03:00'),

(10, 'CAMBIO_DESTINO', 'Cambio de destino solicitado por el rider', 2.00, '2026-03-14 21:20:00');

-- =========================================
-- AUDITORIA_EVENTO
-- =========================================
INSERT INTO auditoria_evento (tabla_afectada, id_registro, accion, detalle, usuario_bd, fecha_evento) VALUES
('viaje', 1, 'INSERT', 'Creacion del viaje 1', 'root@localhost', '2026-03-10 08:00:00'),
('oferta', 1, 'UPDATE', 'Oferta aceptada por el driver 1', 'root@localhost', '2026-03-10 08:01:00'),
('ajuste_tarifa', 1, 'INSERT', 'Ajuste por tiempo de espera', 'root@localhost', '2026-03-10 08:06:00'),

('viaje', 2, 'INSERT', 'Creacion del viaje 2', 'root@localhost', '2026-03-10 09:15:00'),
('oferta', 3, 'UPDATE', 'Oferta aceptada por el driver 2', 'root@localhost', '2026-03-10 09:16:00'),

('viaje', 4, 'INSERT', 'Creacion del viaje 4', 'root@localhost', '2026-03-11 13:30:00'),
('ajuste_tarifa', 3, 'INSERT', 'Ajuste por peaje', 'root@localhost', '2026-03-11 13:40:00'),

('viaje', 5, 'INSERT', 'Creacion del viaje 5', 'root@localhost', '2026-03-12 18:00:00'),
('viaje', 6, 'UPDATE', 'Viaje cancelado por el rider', 'root@localhost', '2026-03-12 19:20:00'),

('viaje', 8, 'INSERT', 'Creacion del viaje 8', 'root@localhost', '2026-03-13 14:00:00'),
('ajuste_tarifa', 5, 'INSERT', 'Ajuste por suplemento de demanda', 'root@localhost', '2026-03-13 14:03:00'),

('viaje', 9, 'UPDATE', 'Viaje 9 pasa a estado EN_CURSO', 'root@localhost', '2026-03-19 17:36:00');