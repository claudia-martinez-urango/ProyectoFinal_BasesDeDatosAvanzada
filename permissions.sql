USE ride_hailing;

-- 1. Borrar usuarios si ya existen
DROP USER IF EXISTS 'admin_app'@'%';
DROP USER IF EXISTS 'operador_app'@'%';
DROP USER IF EXISTS 'analista_app'@'%';
DROP USER IF EXISTS 'backup_app'@'%';
DROP USER IF EXISTS 'consulta_app'@'%';

-- 2. Crear usuarios

CREATE USER 'admin_app'@'%' IDENTIFIED BY 'Admin123!';
CREATE USER 'operador_app'@'%' IDENTIFIED BY 'Operador123!';
CREATE USER 'analista_app'@'%' IDENTIFIED BY 'Analista123!';
CREATE USER 'backup_app'@'%' IDENTIFIED BY 'Backup123!';
CREATE USER 'consulta_app'@'%' IDENTIFIED BY 'Consulta123!';

-- 3. Admin (todos los permisos)
GRANT ALL PRIVILEGES ON ride_hailing.* TO 'admin_app'@'%';

-- 4. Operador (uso normal de la app)
-- usuarios
GRANT SELECT, INSERT, UPDATE ON ride_hailing.usuario TO 'operador_app'@'%';
GRANT SELECT, INSERT, UPDATE ON ride_hailing.rider TO 'operador_app'@'%';
GRANT SELECT, INSERT, UPDATE ON ride_hailing.driver TO 'operador_app'@'%';

-- vehículos
GRANT SELECT, INSERT, UPDATE ON ride_hailing.vehiculo TO 'operador_app'@'%';
GRANT SELECT, INSERT, UPDATE ON ride_hailing.driver_vehiculo TO 'operador_app'@'%';

-- viajes y ofertas
GRANT SELECT, INSERT, UPDATE ON ride_hailing.viaje TO 'operador_app'@'%';
GRANT SELECT, INSERT, UPDATE ON ride_hailing.oferta TO 'operador_app'@'%';

-- ajustes
GRANT SELECT, INSERT, UPDATE ON ride_hailing.ajuste_tarifa TO 'operador_app'@'%';
GRANT SELECT ON ride_hailing.tipo_ajuste_tarifa TO 'operador_app'@'%';

-- incidencias y valoraciones
GRANT SELECT, INSERT, UPDATE ON ride_hailing.incidencia TO 'operador_app'@'%';
GRANT SELECT, INSERT ON ride_hailing.calificacion TO 'operador_app'@'%';

-- método de pago (solo consultar)
GRANT SELECT ON ride_hailing.metodo_pago TO 'operador_app'@'%';

-- auditoría
GRANT SELECT, INSERT ON ride_hailing.auditoria_evento TO 'operador_app'@'%';

-- 5. Analista (solo lectura)
GRANT SELECT ON ride_hailing.* TO 'analista_app'@'%';

-- 6. Backup (copias de seguridad)
GRANT SELECT, SHOW VIEW, LOCK TABLES ON ride_hailing.* TO 'backup_app'@'%';

-- 7. Consulta (solo leer datos)
GRANT SELECT ON ride_hailing.* TO 'consulta_app'@'%';

-- 8. Aplicar cambios
FLUSH PRIVILEGES;

-- 9. Ver permisos
SHOW GRANTS FOR 'admin_app'@'%';
SHOW GRANTS FOR 'operador_app'@'%';
SHOW GRANTS FOR 'analista_app'@'%';
SHOW GRANTS FOR 'backup_app'@'%';
SHOW GRANTS FOR 'consulta_app'@'%';