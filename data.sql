USE ride_hailing;

-- Companies
INSERT INTO company (nombre, cif, telefono, email, activa) VALUES
('MoveFast Mobility', 'A12345678', '911111111', 'contacto@movefast.com', TRUE),
('UrbanGo Transport', 'B87654321', '922222222', 'info@urbango.com', TRUE),
('CityRide Partners', 'C11223344', '933333333', 'support@cityride.com', TRUE),
('BlueCab Services', 'D55667788', '944444444', 'hello@bluecab.com', TRUE),
('MetroDrive Group', 'E99887766', '955555555', 'contact@metrodrive.com', FALSE);

-- Usuarios
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
('Nuria', 'Calvo Reyes', 'nuria.calvo@email.com', '601666666', '2026-02-09 11:30:00', TRUE),
('Mario', 'Serrano Ruiz', 'mario.serrano@email.com', '602111111', '2026-02-10 12:00:00', TRUE),
('Sara', 'Blanco Cano', 'sara.blanco@email.com', '602222222', '2026-02-11 12:10:00', TRUE),
('Diego', 'Perez Vidal', 'diego.perez@email.com', '602333333', '2026-02-12 12:20:00', FALSE);

-- Drivers
INSERT INTO driver (id_usuario, id_company, num_licencia, estado_driver, fecha_alta_driver) VALUES
(1, 1, 'LIC-0001', 'ACTIVO', '2026-01-10 09:30:00'),
(2, 2, 'LIC-0002', 'ACTIVO', '2026-01-11 10:30:00'),
(3, 1, 'LIC-0003', 'ACTIVO', '2026-01-12 11:30:00'),
(4, 3, 'LIC-0004', 'ACTIVO', '2026-01-13 12:30:00'),
(5, 4, 'LIC-0005', 'INACTIVO', '2026-01-14 13:30:00'),
(6, 2, 'LIC-0006', 'ACTIVO', '2026-01-15 14:30:00');

-- Riders
INSERT INTO rider (id_usuario) VALUES
(7),(8),(9),(10),(11),(12),(13),(14),(15),(16),(17),(18);

-- Métodos de pago
INSERT INTO metodo_pago (id_usuario, tipo, detalle, activo) VALUES
(7, 'TARJETA', 'Visa **** 1234', TRUE),
(7, 'PAYPAL', 'lucia.paypal@email.com', TRUE),
(8, 'TARJETA', 'Mastercard **** 9876', TRUE),
(9, 'EFECTIVO', 'Pago en efectivo', TRUE),
(9, 'BIZUM', '600999999', TRUE),
(10, 'TARJETA', 'Visa **** 4455', TRUE),
(11, 'PAYPAL', 'claudia.paypal@email.com', TRUE),
(12, 'TARJETA', 'Visa **** 7744', TRUE),
(13, 'EFECTIVO', 'Pago en efectivo', TRUE),
(14, 'TARJETA', 'Mastercard **** 1111', TRUE),
(15, 'BIZUM', '601666666', TRUE),
(16, 'TARJETA', 'Visa **** 2020', TRUE),
(16, 'PAYPAL', 'mario.paypal@email.com', FALSE),
(17, 'TARJETA', 'Visa **** 3131', TRUE),
(18, 'EFECTIVO', 'Pago en efectivo', FALSE);

-- Vehículos
INSERT INTO vehiculo (matricula, marca, modelo, color, plazas, anio, activo) VALUES
('1234ABC', 'Toyota', 'Corolla', 'Blanco', 4, 2022, TRUE),
('5678DEF', 'Seat', 'Leon', 'Negro', 4, 2021, TRUE),
('9012GHI', 'Tesla', 'Model 3', 'Rojo', 4, 2023, TRUE),
('3456JKL', 'Hyundai', 'Ioniq', 'Azul', 4, 2022, TRUE),
('7890MNO', 'Kia', 'Niro', 'Gris', 4, 2021, TRUE),
('1122PQR', 'Renault', 'Megane', 'Blanco', 4, 2020, TRUE),
('3344STU', 'Volkswagen', 'Golf', 'Negro', 4, 2022, TRUE),
('5566VWX', 'Skoda', 'Octavia', 'Plata', 4, 2019, TRUE),
('7788YZA', 'Peugeot', '308', 'Azul', 4, 2020, FALSE);

-- Histórico conductor - vehículo
INSERT INTO driver_vehiculo (id_usuario_driver, id_vehiculo, fecha_desde, fecha_hasta) VALUES
(1, 1, '2026-02-01 08:00:00', NULL),
(2, 2, '2026-02-01 08:30:00', NULL),
(3, 3, '2026-02-02 09:00:00', NULL),
(4, 4, '2026-02-02 09:30:00', NULL),
(5, 5, '2026-02-03 10:00:00', '2026-03-01 00:00:00'),
(5, 6, '2026-03-01 00:01:00', NULL),
(6, 7, '2026-02-04 10:30:00', NULL),
(2, 8, '2026-01-20 08:00:00', '2026-01-31 20:00:00'),
(3, 9, '2026-01-18 09:00:00', '2026-02-15 18:00:00');

-- Viajes
INSERT INTO viaje (
    id_rider, id_driver_asignado, id_metodo_pago, estado,
    fecha_solicitud, fecha_aceptacion, fecha_inicio, fecha_fin,
    origen_lat, origen_lng, origen_direccion,
    destino_lat, destino_lng, destino_direccion,
    importe_estimado, importe_final, distancia_km, duracion_min
) VALUES
(7, 1, 1, 'FINALIZADO',
 '2026-03-10 08:00:00', '2026-03-10 08:01:00', '2026-03-10 08:05:00', '2026-03-10 08:25:00',
 40.4167750, -3.7037900, 'Puerta del Sol, Madrid',
 40.4378698, -3.8196200, 'Ciudad Universitaria, Madrid',
 12.50, 15.00, 8.40, 20.00),

(8, 2, 3, 'FINALIZADO',
 '2026-03-10 09:15:00', '2026-03-10 09:16:00', '2026-03-10 09:20:00', '2026-03-10 09:48:00',
 40.4280000, -3.7040000, 'Gran Via, Madrid',
 40.4893538, -3.6827461, 'Plaza de Castilla, Madrid',
 14.00, 14.00, 9.10, 28.00),

(9, 4, 4, 'FINALIZADO',
 '2026-03-11 11:00:00', '2026-03-11 11:01:00', '2026-03-11 11:04:00', '2026-03-11 11:35:00',
 40.4520000, -3.6880000, 'Santiago Bernabeu, Madrid',
 40.4152600, -3.7074000, 'Plaza Mayor, Madrid',
 13.00, 13.00, 7.80, 31.00),

(10, 4, 6, 'FINALIZADO',
 '2026-03-11 13:30:00', '2026-03-11 13:31:00', '2026-03-11 13:35:00', '2026-03-11 13:55:00',
 40.4700000, -3.7000000, 'Chamartin, Madrid',
 40.4090000, -3.6920000, 'Retiro, Madrid',
 11.50, 12.50, 6.90, 20.00),

(11, NULL, 7, 'SOLICITADO',
 '2026-03-12 18:00:00', NULL, NULL, NULL,
 40.3900000, -3.7200000, 'Atocha, Madrid',
 40.4500000, -3.7000000, 'Chamartin, Madrid',
 10.00, 10.00, NULL, NULL),

(12, 1, 8, 'CANCELADO',
 '2026-03-12 19:10:00', '2026-03-12 19:11:00', NULL, NULL,
 40.4300000, -3.7100000, 'Callao, Madrid',
 40.4200000, -3.6900000, 'Museo del Prado, Madrid',
 8.50, 8.50, NULL, NULL),

(13, 6, 9, 'FINALIZADO',
 '2026-03-13 08:45:00', '2026-03-13 08:46:00', '2026-03-13 08:50:00', '2026-03-13 09:18:00',
 40.4637000, -3.7492000, 'Moncloa, Madrid',
 40.4169000, -3.7033000, 'Sol, Madrid',
 12.00, 13.25, 8.10, 28.00),

(14, 2, 10, 'FINALIZADO',
 '2026-03-13 14:00:00', '2026-03-13 14:02:00', '2026-03-13 14:05:00', '2026-03-13 14:44:00',
 40.4800000, -3.6600000, 'IFEMA, Madrid',
 40.4100000, -3.7000000, 'La Latina, Madrid',
 16.50, 18.00, 11.20, 39.00),

(15, 3, 11, 'EN_CURSO',
 '2026-03-19 17:30:00', '2026-03-19 17:31:00', '2026-03-19 17:36:00', NULL,
 40.4400000, -3.6900000, 'Nuevos Ministerios, Madrid',
 40.4000000, -3.7200000, 'Legazpi, Madrid',
 13.50, 13.50, NULL, NULL),

(7, 4, 2, 'FINALIZADO',
 '2026-03-14 21:00:00', '2026-03-14 21:01:00', '2026-03-14 21:05:00', '2026-03-14 21:42:00',
 40.4180000, -3.7060000, 'Opera, Madrid',
 40.4700000, -3.7200000, 'Aravaca, Madrid',
 17.00, 19.00, 12.60, 37.00),

(16, 1, 12, 'FINALIZADO',
 '2026-03-15 07:50:00', '2026-03-15 07:51:00', '2026-03-15 07:55:00', '2026-03-15 08:22:00',
 40.4020000, -3.6930000, 'Embajadores, Madrid',
 40.4510000, -3.6890000, 'Plaza Castilla, Madrid',
 15.00, 15.00, 9.40, 27.00),

(17, 14, 14, 'SOLICITADO',
 '2026-03-15 15:10:00', NULL, NULL, NULL,
 40.4320000, -3.7010000, 'Bilbao, Madrid',
 40.4580000, -3.6760000, 'Prosperidad, Madrid',
 9.00, 9.00, NULL, NULL),

(8, 2, 3, 'FINALIZADO',
 '2026-03-16 10:00:00', '2026-03-16 10:01:00', '2026-03-16 10:04:00', '2026-03-16 10:32:00',
 40.4250000, -3.7020000, 'Chueca, Madrid',
 40.4705000, -3.6885000, 'Cuzco, Madrid',
 13.20, 14.70, 8.60, 28.00),

(11, 6, 7, 'FINALIZADO',
 '2026-03-16 18:20:00', '2026-03-16 18:21:00', '2026-03-16 18:25:00', '2026-03-16 18:57:00',
 40.4060000, -3.6900000, 'Atocha Renfe, Madrid',
 40.4590000, -3.7840000, 'Aravaca, Madrid',
 16.80, 19.30, 10.80, 32.00),

(12, 3, 8, 'FINALIZADO',
 '2026-03-17 12:00:00', '2026-03-17 12:02:00', '2026-03-17 12:07:00', '2026-03-17 12:39:00',
 40.4170000, -3.7030000, 'Sol, Madrid',
 40.3770000, -3.6220000, 'Vallecas, Madrid',
 18.00, 18.00, 11.60, 32.00),

(13, NULL, 9, 'CANCELADO',
 '2026-03-17 23:00:00', NULL, NULL, NULL,
 40.4300000, -3.7050000, 'Malasana, Madrid',
 40.4700000, -3.6900000, 'Tetuan, Madrid',
 11.00, 11.00, NULL, NULL);

-- Ofertas
INSERT INTO oferta (id_viaje, id_driver, fecha_envio, estado_oferta, fecha_respuesta) VALUES
(1, 1, '2026-03-10 08:00:10', 'ACEPTADA', '2026-03-10 08:01:00'),
(1, 2, '2026-03-10 08:00:10', 'RECHAZADA', '2026-03-10 08:01:20'),

(2, 2, '2026-03-10 09:15:10', 'ACEPTADA', '2026-03-10 09:16:00'),
(2, 3, '2026-03-10 09:15:10', 'RECHAZADA', '2026-03-10 09:16:40'),

(3, 4, '2026-03-11 11:00:10', 'ACEPTADA', '2026-03-11 11:01:00'),
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
(10, 2, '2026-03-14 21:00:10', 'RECHAZADA', '2026-03-14 21:01:30'),

(11, 1, '2026-03-15 07:50:10', 'ACEPTADA', '2026-03-15 07:51:00'),

(12, 2, '2026-03-15 15:10:10', 'PENDIENTE', NULL),
(12, 4, '2026-03-15 15:10:10', 'PENDIENTE', NULL),

(13, 2, '2026-03-16 10:00:10', 'ACEPTADA', '2026-03-16 10:01:00'),
(13, 6, '2026-03-16 10:00:10', 'RECHAZADA', '2026-03-16 10:01:50'),

(14, 6, '2026-03-16 18:20:10', 'ACEPTADA', '2026-03-16 18:21:00'),

(15, 3, '2026-03-17 12:00:10', 'ACEPTADA', '2026-03-17 12:02:00'),
(15, 1, '2026-03-17 12:00:10', 'RECHAZADA', '2026-03-17 12:02:30'),

(16, 6, '2026-03-17 23:00:10', 'RECHAZADA', '2026-03-17 23:01:00'),
(16, 4, '2026-03-17 23:00:10', 'RECHAZADA', '2026-03-17 23:01:20');

-- Tipos de ajuste
INSERT INTO tipo_ajuste_tarifa (codigo, nombre, descripcion) VALUES
('TIEMPO_ESPERA', 'Tiempo de espera', 'Incremento por espera del conductor'),
('CAMBIO_DESTINO', 'Cambio de destino', 'El usuario modifica el destino durante el viaje'),
('PEAJE', 'Peaje', 'Coste adicional por peajes'),
('SUPLEMENTO_DEMANDA', 'Suplemento por demanda', 'Incremento por alta demanda'),
('DESCUENTO', 'Descuento', 'Ajuste negativo aplicado sobre la tarifa'),
('LIMPIEZA', 'Suplemento de limpieza', 'Coste adicional por incidencia de limpieza');

-- Ajustes de tarifa
INSERT INTO ajuste_tarifa (id_viaje, id_tipo_ajuste, descripcion, importe_ajuste, fecha_ajuste) VALUES
(1, 1, 'El conductor esperó 5 minutos en la recogida', 1.50, '2026-03-10 08:06:00'),
(1, 2, 'Cambio de destino solicitado durante el trayecto', 1.00, '2026-03-10 08:12:00'),
(4, 3, 'Peaje urbano en la ruta', 1.00, '2026-03-11 13:40:00'),
(7, 1, 'Espera adicional en el punto de recogida', 1.25, '2026-03-13 08:52:00'),
(8, 4, 'Alta demanda en zona IFEMA', 1.50, '2026-03-13 14:03:00'),
(10, 2, 'Cambio de destino hacia una zona más alejada', 2.00, '2026-03-14 21:20:00'),
(13, 5, 'Cupón promocional aplicado', -1.50, '2026-03-16 10:15:00'),
(14, 3, 'Peaje de acceso rápido', 2.50, '2026-03-16 18:40:00');

-- Calificaciones
INSERT INTO calificacion (
    id_viaje, id_emisor, id_receptor, rol_emisor, rol_receptor,
    puntuacion, comentario, fecha_calificacion
) VALUES
(1, 7, 1, 'RIDER', 'DRIVER', 5, 'Muy puntual y amable', '2026-03-10 08:30:00'),
(1, 1, 7, 'DRIVER', 'RIDER', 5, 'Todo correcto durante el trayecto', '2026-03-10 08:31:00'),

(2, 8, 2, 'RIDER', 'DRIVER', 4, 'Buen viaje, aunque hubo algo de tráfico', '2026-03-10 10:00:00'),
(2, 2, 8, 'DRIVER', 'RIDER', 5, 'Cliente educado y puntual', '2026-03-10 10:02:00'),

(3, 9, 4, 'RIDER', 'DRIVER', 5, 'Conducción muy buena', '2026-03-11 11:45:00'),
(3, 4, 9, 'DRIVER', 'RIDER', 4, 'Sin incidencias', '2026-03-11 11:46:00'),

(4, 10, 4, 'RIDER', 'DRIVER', 3, 'Llegó bien pero el coche estaba algo sucio', '2026-03-11 14:10:00'),

(7, 13, 6, 'RIDER', 'DRIVER', 4, 'Trayecto correcto', '2026-03-13 09:30:00'),
(7, 6, 13, 'DRIVER', 'RIDER', 5, 'Muy amable', '2026-03-13 09:31:00'),

(8, 14, 2, 'RIDER', 'DRIVER', 5, 'Excelente servicio', '2026-03-13 15:00:00'),
(8, 2, 14, 'DRIVER', 'RIDER', 5, 'Todo perfecto', '2026-03-13 15:01:00'),

(10, 7, 4, 'RIDER', 'DRIVER', 4, 'Buen viaje y buen trato', '2026-03-14 22:00:00'),
(10, 4, 7, 'DRIVER', 'RIDER', 4, 'Buena experiencia', '2026-03-14 22:02:00'),

(11, 16, 1, 'RIDER', 'DRIVER', 5, 'Muy profesional', '2026-03-15 08:40:00'),

(13, 8, 2, 'RIDER', 'DRIVER', 4, 'Todo correcto', '2026-03-16 10:50:00'),
(13, 2, 8, 'DRIVER', 'RIDER', 4, 'Sin problemas', '2026-03-16 10:51:00'),

(14, 11, 6, 'RIDER', 'DRIVER', 2, 'Hubo retraso en la llegada', '2026-03-16 19:20:00'),
(14, 6, 11, 'DRIVER', 'RIDER', 4, 'Cliente correcto', '2026-03-16 19:22:00'),

(15, 12, 3, 'RIDER', 'DRIVER', 5, 'Ruta rápida y cómoda', '2026-03-17 12:50:00'),
(15, 3, 12, 'DRIVER', 'RIDER', 5, 'Muy puntual', '2026-03-17 12:51:00');

-- Incidencias
INSERT INTO incidencia (
    id_viaje, id_usuario_reporta, tipo_incidencia, descripcion,
    estado_incidencia, fecha_reporte, fecha_resolucion
) VALUES
(4, 10, 'LIMPIEZA', 'El vehículo presentaba suciedad en la parte trasera', 'RESUELTA', '2026-03-11 14:05:00', '2026-03-11 18:00:00'),
(6, 12, 'CANCELACION_TARDIA', 'El viaje se canceló después de la aceptación', 'CERRADA', '2026-03-12 19:15:00', '2026-03-12 20:00:00'),
(8, 14, 'RETRASO', 'El conductor tardó más de lo esperado en llegar', 'RESUELTA', '2026-03-13 14:50:00', '2026-03-13 16:00:00'),
(10, 4, 'CAMBIO_RUTA', 'El rider cambió la ruta y se revisó el importe final', 'CERRADA', '2026-03-14 21:25:00', '2026-03-14 22:30:00'),
(14, 11, 'RETRASO', 'El conductor quedó parado varios minutos antes de recoger', 'EN_REVISION', '2026-03-16 19:10:00', NULL),
(15, 3, 'OBJETO_OLVIDADO', 'El rider dejó una mochila en el vehículo', 'ABIERTA', '2026-03-17 13:10:00', NULL),
(16, 13, 'NO_DRIVER_FOUND', 'No hubo conductor disponible para aceptar el viaje', 'CERRADA', '2026-03-17 23:05:00', '2026-03-17 23:30:00');

-- Auditoría
INSERT INTO auditoria_evento (tabla_afectada, id_registro, accion, detalle, usuario_bd, fecha_evento) VALUES
('viaje', 1, 'INSERT', 'Creación del viaje 1', 'root@localhost', '2026-03-10 08:00:00'),
('oferta', 1, 'UPDATE', 'Oferta aceptada por el driver 1', 'root@localhost', '2026-03-10 08:01:00'),
('ajuste_tarifa', 1, 'INSERT', 'Ajuste por tiempo de espera', 'root@localhost', '2026-03-10 08:06:00'),
('viaje', 4, 'INSERT', 'Creación del viaje 4', 'root@localhost', '2026-03-11 13:30:00'),
('incidencia', 1, 'INSERT', 'Incidencia de limpieza registrada', 'root@localhost', '2026-03-11 14:05:00'),
('viaje', 6, 'UPDATE', 'Viaje cancelado por el rider', 'root@localhost', '2026-03-12 19:15:00'),
('calificacion', 10, 'INSERT', 'Calificación registrada por rider', 'root@localhost', '2026-03-13 15:00:00'),
('viaje', 10, 'UPDATE', 'Importe final ajustado por cambio de destino', 'root@localhost', '2026-03-14 21:20:00'),
('ajuste_tarifa', 7, 'INSERT', 'Descuento aplicado al viaje 13', 'root@localhost', '2026-03-16 10:15:00'),
('incidencia', 5, 'INSERT', 'Incidencia en revisión por retraso', 'root@localhost', '2026-03-16 19:10:00'),
('incidencia', 6, 'INSERT', 'Objeto olvidado reportado', 'root@localhost', '2026-03-17 13:10:00');