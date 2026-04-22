USE ride_hailing;


-- BACKUP.SQL
-- Copias de seguridad y recuperación
-- Este archivo recoge ejemplos de backup y restore.
-- Los comandos con mysqldump o mysql se lanzan desde terminal.

-- 1. Copia completa de la base de datos
-- mysqldump -u root -p ride_hailing > backup_completo.sql

-- Esta copia incluye:
-- - tablas
-- - datos
-- - índices
-- - vistas

-- 2. Copia solo de la estructura
-- mysqldump -u root -p --no-data ride_hailing > backup_estructura.sql

-- Sirve para guardar solo el esquema.

-- 3. Copia solo de los datos
-- mysqldump -u root -p --no-create-info ride_hailing > backup_datos.sql

-- Sirve para guardar solo los registros.


-- 4. Copia de tablas importantes
-- mysqldump -u root -p ride_hailing viaje oferta incidencia calificacion > backup_operativa.sql

-- Esta opción puede ser útil para guardar solo la parte más crítica.


-- 5. Copia usando Docker
-- docker exec mysql_ride_hailing_PRACTICA \
-- mysqldump -uroot -proot_password ride_hailing > backup_docker.sql


-- 6. Propuesta de plan de copias
-- Copia completa: una vez al día
-- Copia de tablas importantes: cada pocas horas
-- Guardar copias diarias durante 7 días
-- Guardar copias semanales durante 4 semanas
-- Guardar copias mensuales durante 6 meses

-- 7. Recuperación
-- Restaurar una copia completa:
-- mysql -u root -p ride_hailing < backup_completo.sql

-- Restaurar una copia hecha desde Docker:
-- docker exec -i mysql_ride_hailing_PRACTICA \
-- mysql -uroot -proot_password ride_hailing < backup_docker.sql


-- 8. Bloqueo de tablas durante la copia
-- Si se quiere asegurar consistencia, se pueden bloquear
-- las tablas mientras se hace el backup.

FLUSH TABLES WITH READ LOCK;

-- Aquí se ejecutaría la copia

UNLOCK TABLES;


-- 9. Comprobación después de restaurar
SHOW TABLES;

SELECT COUNT(*) AS total_usuarios FROM usuario;
SELECT COUNT(*) AS total_viajes FROM viaje;
SELECT COUNT(*) AS total_ofertas FROM oferta;
SELECT COUNT(*) AS total_incidencias FROM incidencia;
SELECT COUNT(*) AS total_calificaciones FROM calificacion;


-- 10. Observaciones
-- Conviene automatizar las copias con tareas programadas.
-- También es recomendable guardar una copia fuera del equipo
-- o del servidor principal.
-- No basta con hacer el backup: hay que probar de vez en cuando
-- que la restauración funciona correctamente.