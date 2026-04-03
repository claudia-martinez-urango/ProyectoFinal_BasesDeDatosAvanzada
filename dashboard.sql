USE ride_hailing;

-- ******************************************************
-- DASHBOARD.SQL
-- Métricas de negocio + métricas básicas de BD
-- ******************************************************

-- ******************************************************
-- 1. MÉTRICAS DE NEGOCIO
-- ******************************************************

-- 1.1 Tasa de aceptación por conductor
SELECT
    d.id_usuario AS id_driver,
    CONCAT(u.nombre, ' ', u.apellidos) AS driver,
    COUNT(o.id_oferta) AS ofertas_recibidas,
    SUM(CASE WHEN o.estado_oferta = 'ACEPTADA' THEN 1 ELSE 0 END) AS ofertas_aceptadas,
    ROUND(
        100 * SUM(CASE WHEN o.estado_oferta = 'ACEPTADA' THEN 1 ELSE 0 END) / NULLIF(COUNT(o.id_oferta), 0),
        2
    ) AS tasa_aceptacion_pct
FROM driver d
JOIN usuario u ON d.id_usuario = u.id_usuario
LEFT JOIN oferta o ON d.id_usuario = o.id_driver
GROUP BY d.id_usuario, u.nombre, u.apellidos
ORDER BY tasa_aceptacion_pct DESC, ofertas_aceptadas DESC;


-- 1.2 Tasa de aceptación por company
SELECT
    c.id_company,
    c.nombre AS company,
    COUNT(o.id_oferta) AS ofertas_recibidas,
    SUM(CASE WHEN o.estado_oferta = 'ACEPTADA' THEN 1 ELSE 0 END) AS ofertas_aceptadas,
    ROUND(
        100 * SUM(CASE WHEN o.estado_oferta = 'ACEPTADA' THEN 1 ELSE 0 END) / NULLIF(COUNT(o.id_oferta), 0),
        2
    ) AS tasa_aceptacion_pct
FROM company c
JOIN driver d ON c.id_company = d.id_company
LEFT JOIN oferta o ON d.id_usuario = o.id_driver
GROUP BY c.id_company, c.nombre
ORDER BY tasa_aceptacion_pct DESC, ofertas_aceptadas DESC;


-- 1.3 Tiempo medio y kilometraje medio de viajes finalizados
SELECT
    ROUND(AVG(duracion_min), 2) AS tiempo_medio_min,
    ROUND(AVG(distancia_km), 2) AS kilometraje_medio_km,
    COUNT(*) AS total_viajes_finalizados
FROM viaje
WHERE estado = 'FINALIZADO';


-- 1.4 Ingresos por conductor
SELECT
    d.id_usuario AS id_driver,
    CONCAT(u.nombre, ' ', u.apellidos) AS driver,
    COUNT(v.id_viaje) AS viajes_finalizados,
    ROUND(COALESCE(SUM(v.importe_final), 0), 2) AS ingresos_totales,
    ROUND(COALESCE(AVG(v.importe_final), 0), 2) AS ingreso_medio_por_viaje
FROM driver d
JOIN usuario u ON d.id_usuario = u.id_usuario
LEFT JOIN viaje v
    ON v.id_driver_asignado = d.id_usuario
   AND v.estado = 'FINALIZADO'
GROUP BY d.id_usuario, u.nombre, u.apellidos
ORDER BY ingresos_totales DESC;


-- 1.5 Ingresos por company
SELECT
    c.id_company,
    c.nombre AS company,
    COUNT(v.id_viaje) AS viajes_finalizados,
    ROUND(COALESCE(SUM(v.importe_final), 0), 2) AS ingresos_totales,
    ROUND(COALESCE(AVG(v.importe_final), 0), 2) AS ingreso_medio_por_viaje
FROM company c
JOIN driver d ON c.id_company = d.id_company
LEFT JOIN viaje v
    ON v.id_driver_asignado = d.id_usuario
   AND v.estado = 'FINALIZADO'
GROUP BY c.id_company, c.nombre
ORDER BY ingresos_totales DESC;


-- 1.6 Euros por kilómetro y euros por minuto por conductor
SELECT
    d.id_usuario AS id_driver,
    CONCAT(u.nombre, ' ', u.apellidos) AS driver,
    ROUND(COALESCE(SUM(v.importe_final), 0), 2) AS ingresos_totales,
    ROUND(COALESCE(SUM(v.distancia_km), 0), 2) AS km_totales,
    ROUND(COALESCE(SUM(v.duracion_min), 0), 2) AS min_totales,
    ROUND(COALESCE(SUM(v.importe_final) / NULLIF(SUM(v.distancia_km), 0), 0), 2) AS euros_por_km,
    ROUND(COALESCE(SUM(v.importe_final) / NULLIF(SUM(v.duracion_min), 0), 0), 2) AS euros_por_min
FROM driver d
JOIN usuario u ON d.id_usuario = u.id_usuario
LEFT JOIN viaje v
    ON v.id_driver_asignado = d.id_usuario
   AND v.estado = 'FINALIZADO'
GROUP BY d.id_usuario, u.nombre, u.apellidos
ORDER BY ingresos_totales DESC;


-- 1.7 Euros por kilómetro y euros por minuto por company
SELECT
    c.id_company,
    c.nombre AS company,
    ROUND(COALESCE(SUM(v.importe_final), 0), 2) AS ingresos_totales,
    ROUND(COALESCE(SUM(v.distancia_km), 0), 2) AS km_totales,
    ROUND(COALESCE(SUM(v.duracion_min), 0), 2) AS min_totales,
    ROUND(COALESCE(SUM(v.importe_final) / NULLIF(SUM(v.distancia_km), 0), 0), 2) AS euros_por_km,
    ROUND(COALESCE(SUM(v.importe_final) / NULLIF(SUM(v.duracion_min), 0), 0), 2) AS euros_por_min
FROM company c
JOIN driver d ON c.id_company = d.id_company
LEFT JOIN viaje v
    ON v.id_driver_asignado = d.id_usuario
   AND v.estado = 'FINALIZADO'
GROUP BY c.id_company, c.nombre
ORDER BY ingresos_totales DESC;


-- 1.8 Viajes por hora
SELECT
    HOUR(fecha_solicitud) AS hora_dia,
    COUNT(*) AS total_viajes
FROM viaje
GROUP BY HOUR(fecha_solicitud)
ORDER BY hora_dia;


-- 1.9 Viajes por estado
SELECT
    estado,
    COUNT(*) AS total_viajes
FROM viaje
GROUP BY estado
ORDER BY total_viajes DESC;


-- 1.10 Ofertas aceptadas, rechazadas y pendientes
SELECT
    estado_oferta,
    COUNT(*) AS total_ofertas
FROM oferta
GROUP BY estado_oferta
ORDER BY total_ofertas DESC;


-- 1.11 Top conductores por número de viajes finalizados
SELECT
    d.id_usuario AS id_driver,
    CONCAT(u.nombre, ' ', u.apellidos) AS driver,
    COUNT(v.id_viaje) AS viajes_finalizados
FROM driver d
JOIN usuario u ON d.id_usuario = u.id_usuario
LEFT JOIN viaje v
    ON v.id_driver_asignado = d.id_usuario
   AND v.estado = 'FINALIZADO'
GROUP BY d.id_usuario, u.nombre, u.apellidos
ORDER BY viajes_finalizados DESC, driver ASC;


-- 1.12 Top companies por ingresos
SELECT
    c.id_company,
    c.nombre AS company,
    ROUND(COALESCE(SUM(v.importe_final), 0), 2) AS ingresos_totales
FROM company c
JOIN driver d ON c.id_company = d.id_company
LEFT JOIN viaje v
    ON v.id_driver_asignado = d.id_usuario
   AND v.estado = 'FINALIZADO'
GROUP BY c.id_company, c.nombre
ORDER BY ingresos_totales DESC;


-- ******************************************************
-- 2. VISTAS ÚTILES PARA EL DASHBOARD
-- ******************************************************

CREATE OR REPLACE VIEW v_dashboard_viajes_finalizados AS
SELECT
    v.id_viaje,
    v.fecha_solicitud,
    v.fecha_inicio,
    v.fecha_fin,
    v.estado,
    v.distancia_km,
    v.duracion_min,
    v.importe_final,
    d.id_usuario AS id_driver,
    CONCAT(u.nombre, ' ', u.apellidos) AS driver,
    c.id_company,
    c.nombre AS company
FROM viaje v
LEFT JOIN driver d ON v.id_driver_asignado = d.id_usuario
LEFT JOIN usuario u ON d.id_usuario = u.id_usuario
LEFT JOIN company c ON d.id_company = c.id_company
WHERE v.estado = 'FINALIZADO';


CREATE OR REPLACE VIEW v_dashboard_ofertas AS
SELECT
    o.id_oferta,
    o.id_viaje,
    o.id_driver,
    CONCAT(u.nombre, ' ', u.apellidos) AS driver,
    c.nombre AS company,
    o.estado_oferta,
    o.fecha_envio,
    o.fecha_respuesta
FROM oferta o
JOIN driver d ON o.id_driver = d.id_usuario
JOIN usuario u ON d.id_usuario = u.id_usuario
JOIN company c ON d.id_company = c.id_company;


-- ******************************************************
-- 3. MÉTRICAS DE BASE DE DATOS
-- ******************************************************

-- 3.1 Número de tablas del esquema
SELECT
    table_schema,
    COUNT(*) AS total_tablas
FROM information_schema.tables
WHERE table_schema = 'ride_hailing'
GROUP BY table_schema;


-- 3.2 Tamaño de tablas (datos + índices)
SELECT
    table_name,
    ROUND(data_length / 1024 / 1024, 2) AS datos_mb,
    ROUND(index_length / 1024 / 1024, 2) AS indices_mb,
    ROUND((data_length + index_length) / 1024 / 1024, 2) AS total_mb
FROM information_schema.tables
WHERE table_schema = 'ride_hailing'
ORDER BY total_mb DESC;


-- 3.3 Estado general de conexiones
SHOW STATUS LIKE 'Threads_connected';
SHOW STATUS LIKE 'Connections';
SHOW VARIABLES LIKE 'max_connections';


-- 3.4 Uptime del servidor
SHOW STATUS LIKE 'Uptime';


-- 3.5 Slow query log y umbral
SHOW VARIABLES LIKE 'slow_query_log%';
SHOW VARIABLES LIKE 'long_query_time';


-- 3.6 Procesos activos
SHOW PROCESSLIST;


-- 3.7 Estadísticas de viajes
SELECT
    COUNT(*) AS total_viajes,
    SUM(CASE WHEN estado = 'FINALIZADO' THEN 1 ELSE 0 END) AS viajes_finalizados,
    SUM(CASE WHEN estado = 'CANCELADO' THEN 1 ELSE 0 END) AS viajes_cancelados,
    SUM(CASE WHEN estado = 'EN_CURSO' THEN 1 ELSE 0 END) AS viajes_en_curso,
    SUM(CASE WHEN estado = 'SOLICITADO' THEN 1 ELSE 0 END) AS viajes_solicitados
FROM viaje;


-- 3.8 Estadísticas de ofertas
SELECT
    COUNT(*) AS total_ofertas,
    SUM(CASE WHEN estado_oferta = 'ACEPTADA' THEN 1 ELSE 0 END) AS ofertas_aceptadas,
    SUM(CASE WHEN estado_oferta = 'RECHAZADA' THEN 1 ELSE 0 END) AS ofertas_rechazadas,
    SUM(CASE WHEN estado_oferta = 'PENDIENTE' THEN 1 ELSE 0 END) AS ofertas_pendientes
FROM oferta;