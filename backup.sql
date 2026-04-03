-- *******************************************************
-- BACKUP.SQL
-- Plan de backup y recuperación para ride_hailing
-- *******************************************************

-- *******************************************************
-- 1. BACKUP COMPLETO (FULL BACKUP)
-- *******************************************************
-- Este comando se ejecuta desde terminal, no dentro de MySQL

-- Ejemplo:
-- mysqldump -u root -p ride_hailing > backup_full.sql

-- Incluye:
-- - estructura (schema)
-- - datos (data)
-- - vistas
-- - índices

-- *******************************************************
-- 2. BACKUP SOLO DE ESTRUCTURA
-- *******************************************************
-- mysqldump -u root -p --no-data ride_hailing > backup_schema.sql


-- *******************************************************
-- 3. BACKUP SOLO DE DATOS
-- *******************************************************
-- mysqldump -u root -p --no-create-info ride_hailing > backup_data.sql


-- *******************************************************
-- 4. BACKUP DE TABLAS CRÍTICAS
-- *******************************************************
-- Ejemplo: solo viajes y ofertas

-- mysqldump -u root -p ride_hailing viaje oferta > backup_operativa.sql


-- *******************************************************
-- 5. BACKUP CON DOCKER
-- *******************************************************
-- Desde fuera del contenedor:

-- docker exec mysql_ride_hailing_PRACTICA \
-- mysqldump -uroot -proot_password ride_hailing > backup_docker.sql


-- *******************************************************
-- 6. PLAN DE BACKUP PROPUESTO
-- *******************************************************
-- - Backup completo: 1 vez al día
-- - Backup incremental (datos críticos): cada hora
-- - Retención:
--     - diarios: 7 días
--     - semanales: 4 semanas
--     - mensuales: 6 meses


-- *******************************************************
-- 7. RECUPERACIÓN (RESTORE)
-- *******************************************************

-- Restaurar backup completo:
-- mysql -u root -p ride_hailing < backup_full.sql

-- Restaurar desde Docker:
-- docker exec -i mysql_ride_hailing_PRACTICA \
-- mysql -uroot -proot_password ride_hailing < backup_docker.sql


-- *******************************************************
-- 8. BLOQUEO DURANTE BACKUP (CONSISTENCIA)
-- *******************************************************

-- Para evitar inconsistencias en backups grandes:

FLUSH TABLES WITH READ LOCK;

-- (ejecutar backup aquí)

UNLOCK TABLES;


-- *******************************************************
-- 9. COMPROBACIÓN DE BACKUP
-- *******************************************************

-- Verificar tablas tras restauración:
SHOW TABLES;

-- Verificar datos:
SELECT COUNT(*) FROM viaje;
SELECT COUNT(*) FROM oferta;
SELECT COUNT(*) FROM usuario;


-- *******************************************************
-- 10. CONSIDERACIONES
-- *******************************************************

-- - Usar backups automáticos (cron jobs o tareas programadas)
-- - Almacenar backups en ubicaciones externas (cloud, NAS)
-- - Testear restauración periódicamente
-- - Monitorizar tamaño de backups y tiempos de ejecución