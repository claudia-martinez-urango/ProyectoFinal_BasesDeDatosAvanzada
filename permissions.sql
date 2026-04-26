USE ride_hailing;

-- 1. Borrar usuarios si ya existen
DROP USER IF EXISTS 'admin_app'@'%';
DROP USER IF EXISTS 'operador_app'@'%';
DROP USER IF EXISTS 'analista_app'@'%';
DROP USER IF EXISTS 'backup_app'@'%';
DROP USER IF EXISTS 'consulta_app'@'%';
DROP USER IF EXISTS 'dispatcher_app'@'%';
DROP USER IF EXISTS 'fleet_app'@'%';
DROP USER IF EXISTS 'support_app'@'%';
DROP USER IF EXISTS 'finance_app'@'%';
DROP USER IF EXISTS 'fraud_app'@'%';
DROP USER IF EXISTS 'dashboard_app'@'%';
-- 2. Crear usuarios

CREATE USER 'admin_app'@'%' IDENTIFIED BY 'Admin123!';
CREATE USER 'operador_app'@'%' IDENTIFIED BY 'Operador123!';
CREATE USER 'analista_app'@'%' IDENTIFIED BY 'Analista123!';
CREATE USER 'backup_app'@'%' IDENTIFIED BY 'Backup123!';
CREATE USER 'consulta_app'@'%' IDENTIFIED BY 'Consulta123!';
CREATE USER 'dispatcher_app'@'%' IDENTIFIED BY 'Dispatcher123!';
CREATE USER 'fleet_app'@'%' IDENTIFIED BY 'Fleet123!';
CREATE USER 'support_app'@'%' IDENTIFIED BY 'Support123!';
CREATE USER 'finance_app'@'%' IDENTIFIED BY 'Finance123!';
CREATE USER 'fraud_app'@'%' IDENTIFIED BY 'Fraud123!';
CREATE USER 'dashboard_app'@'%' IDENTIFIED BY 'Dashboard123!';

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
GRANT SELECT, SHOW VIEW, LOCK TABLES, TRIGGER, EVENT ON ride_hailing.* TO 'backup_app'@'%';
GRANT SHOW_ROUTINE ON *.* TO 'backup_app'@'%';

-- 7. Consulta (solo leer datos)
GRANT SELECT ON ride_hailing.* TO 'consulta_app'@'%';

-- 8. Dispatcher: gestiona viajes y ofertas
GRANT SELECT ON ride_hailing.usuario TO 'dispatcher_app'@'%';
GRANT SELECT ON ride_hailing.rider TO 'dispatcher_app'@'%';
GRANT SELECT ON ride_hailing.driver TO 'dispatcher_app'@'%';
GRANT SELECT ON ride_hailing.company TO 'dispatcher_app'@'%';
GRANT SELECT ON ride_hailing.vehiculo TO 'dispatcher_app'@'%';
GRANT SELECT ON ride_hailing.driver_vehiculo TO 'dispatcher_app'@'%';

GRANT SELECT, INSERT, UPDATE ON ride_hailing.viaje TO 'dispatcher_app'@'%';
GRANT SELECT, INSERT, UPDATE ON ride_hailing.oferta TO 'dispatcher_app'@'%';

GRANT EXECUTE ON PROCEDURE ride_hailing.sp_aceptar_oferta TO 'dispatcher_app'@'%';


-- 9. Fleet: gestiona flota, vehículos y conductores
GRANT SELECT ON ride_hailing.usuario TO 'fleet_app'@'%';
GRANT SELECT ON ride_hailing.company TO 'fleet_app'@'%';

GRANT SELECT, INSERT, UPDATE ON ride_hailing.driver TO 'fleet_app'@'%';
GRANT SELECT, INSERT, UPDATE ON ride_hailing.vehiculo TO 'fleet_app'@'%';
GRANT SELECT, INSERT, UPDATE ON ride_hailing.driver_vehiculo TO 'fleet_app'@'%';


-- 10. Support: gestiona incidencias
GRANT SELECT ON ride_hailing.usuario TO 'support_app'@'%';
GRANT SELECT ON ride_hailing.rider TO 'support_app'@'%';
GRANT SELECT ON ride_hailing.driver TO 'support_app'@'%';
GRANT SELECT ON ride_hailing.viaje TO 'support_app'@'%';
GRANT SELECT ON ride_hailing.oferta TO 'support_app'@'%';

GRANT SELECT, INSERT ON ride_hailing.incidencia TO 'support_app'@'%';
GRANT UPDATE ON ride_hailing.incidencia TO 'support_app'@'%';


-- 11. Finance: consulta ingresos, pagos y ajustes
GRANT SELECT ON ride_hailing.company TO 'finance_app'@'%';
GRANT SELECT ON ride_hailing.usuario TO 'finance_app'@'%';
GRANT SELECT ON ride_hailing.driver TO 'finance_app'@'%';
GRANT SELECT ON ride_hailing.viaje TO 'finance_app'@'%';
GRANT SELECT ON ride_hailing.metodo_pago TO 'finance_app'@'%';
GRANT SELECT ON ride_hailing.ajuste_tarifa TO 'finance_app'@'%';
GRANT SELECT ON ride_hailing.tipo_ajuste_tarifa TO 'finance_app'@'%';

GRANT INSERT ON ride_hailing.ajuste_tarifa TO 'finance_app'@'%';


-- 12. Fraud: auditoría y revisión de comportamiento sospechoso
GRANT SELECT ON ride_hailing.auditoria_evento TO 'fraud_app'@'%';
GRANT SELECT ON ride_hailing.incidencia TO 'fraud_app'@'%';
GRANT SELECT ON ride_hailing.usuario TO 'fraud_app'@'%';
GRANT SELECT ON ride_hailing.rider TO 'fraud_app'@'%';
GRANT SELECT ON ride_hailing.driver TO 'fraud_app'@'%';
GRANT SELECT ON ride_hailing.viaje TO 'fraud_app'@'%';
GRANT SELECT ON ride_hailing.oferta TO 'fraud_app'@'%';
GRANT SELECT ON ride_hailing.calificacion TO 'fraud_app'@'%';


-- 13. Dashboard: usuario para cuadros de mando
GRANT SELECT ON ride_hailing.* TO 'dashboard_app'@'%';

-- 14. Aplicar cambios
FLUSH PRIVILEGES;

-- 15. Ver permisos
SHOW GRANTS FOR 'admin_app'@'%';
SHOW GRANTS FOR 'operador_app'@'%';
SHOW GRANTS FOR 'analista_app'@'%';
SHOW GRANTS FOR 'backup_app'@'%';
SHOW GRANTS FOR 'consulta_app'@'%';
SHOW GRANTS FOR 'dispatcher_app'@'%';
SHOW GRANTS FOR 'fleet_app'@'%';
SHOW GRANTS FOR 'support_app'@'%';
SHOW GRANTS FOR 'finance_app'@'%';
SHOW GRANTS FOR 'fraud_app'@'%';
SHOW GRANTS FOR 'dashboard_app'@'%';