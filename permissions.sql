USE ride_hailing;

-- *******************************************************
-- PERMISSIONS.SQL
-- Seguridad: usuarios y permisos de base de datos
-- *******************************************************

-- *******************************************************
-- 1. LIMPIEZA PREVIA
-- *******************************************************
DROP USER IF EXISTS 'admin_app'@'%';
DROP USER IF EXISTS 'operator_app'@'%';
DROP USER IF EXISTS 'analyst_app'@'%';
DROP USER IF EXISTS 'backup_user'@'%';
DROP USER IF EXISTS 'readonly_user'@'%';

-- *******************************************************
-- 2. CREACIÓN DE USUARIOS
-- *******************************************************
CREATE USER 'admin_app'@'%' IDENTIFIED BY 'Admin123!';
CREATE USER 'operator_app'@'%' IDENTIFIED BY 'Operator123!';
CREATE USER 'analyst_app'@'%' IDENTIFIED BY 'Analyst123!';
CREATE USER 'backup_user'@'%' IDENTIFIED BY 'Backup123!';
CREATE USER 'readonly_user'@'%' IDENTIFIED BY 'Readonly123!';

-- *******************************************************
-- 3. PERMISOS PARA ADMINISTRADOR DE APLICACIÓN
-- Control total sobre la BD de la práctica
-- *******************************************************
GRANT ALL PRIVILEGES ON ride_hailing.* TO 'admin_app'@'%';

-- *******************************************************
-- 4. PERMISOS PARA OPERATIVA DE LA APP
-- Puede trabajar con viajes, ofertas, ajustes y lectura general
-- *******************************************************
GRANT SELECT, INSERT, UPDATE ON ride_hailing.usuario TO 'operator_app'@'%';
GRANT SELECT, INSERT, UPDATE ON ride_hailing.rider TO 'operator_app'@'%';
GRANT SELECT, INSERT, UPDATE ON ride_hailing.driver TO 'operator_app'@'%';
GRANT SELECT, INSERT, UPDATE ON ride_hailing.vehiculo TO 'operator_app'@'%';
GRANT SELECT, INSERT, UPDATE ON ride_hailing.driver_vehiculo TO 'operator_app'@'%';
GRANT SELECT, INSERT, UPDATE ON ride_hailing.viaje TO 'operator_app'@'%';
GRANT SELECT, INSERT, UPDATE ON ride_hailing.oferta TO 'operator_app'@'%';
GRANT SELECT, INSERT, UPDATE ON ride_hailing.ajuste_tarifa TO 'operator_app'@'%';
GRANT SELECT, INSERT ON ride_hailing.auditoria_evento TO 'operator_app'@'%';

-- *******************************************************
-- 5. PERMISOS PARA ANALISTA / DASHBOARD
-- Solo lectura sobre tablas y vistas analíticas
-- *******************************************************
GRANT SELECT ON ride_hailing.* TO 'analyst_app'@'%';

-- *******************************************************
-- 6. PERMISOS PARA BACKUP
-- Permisos mínimos orientados a exportación/lectura
-- *******************************************************
GRANT SELECT, SHOW VIEW, LOCK TABLES ON ride_hailing.* TO 'backup_user'@'%';

-- *******************************************************
-- 7. PERMISOS PARA SOLO LECTURA
-- Usuario muy restringido para consultas simples
-- *******************************************************
GRANT SELECT ON ride_hailing.* TO 'readonly_user'@'%';

-- *******************************************************
-- 8. APLICAR CAMBIOS
-- *******************************************************
FLUSH PRIVILEGES;

-- *******************************************************
-- 9. COMPROBACIÓN DE PERMISOS
-- *******************************************************
SHOW GRANTS FOR 'admin_app'@'%';
SHOW GRANTS FOR 'operator_app'@'%';
SHOW GRANTS FOR 'analyst_app'@'%';
SHOW GRANTS FOR 'backup_user'@'%';
SHOW GRANTS FOR 'readonly_user'@'%';