USE ride_hailing;

-- Tasa de aceptación por conductor
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

-- Tasa de aceptación por company
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

-- Tiempo medio y kilometraje medio
SELECT
    ROUND(AVG(duracion_min), 2) AS tiempo_medio_min,
    ROUND(AVG(distancia_km), 2) AS kilometraje_medio_km,
    COUNT(*) AS total_viajes_finalizados
FROM viaje
WHERE estado = 'FINALIZADO';

-- Ingresos por conductor
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

-- Ingresos por company
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

-- Euros por km y por minuto por conductor
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

-- Euros por km y por minuto por company
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

-- Viajes por hora
SELECT
    HOUR(fecha_solicitud) AS hora_dia,
    COUNT(*) AS total_viajes
FROM viaje
GROUP BY HOUR(fecha_solicitud)
ORDER BY hora_dia;

-- Viajes por estado
SELECT
    estado,
    COUNT(*) AS total_viajes
FROM viaje
GROUP BY estado
ORDER BY total_viajes DESC;

-- Ofertas por estado
SELECT
    estado_oferta,
    COUNT(*) AS total_ofertas
FROM oferta
GROUP BY estado_oferta
ORDER BY total_ofertas DESC;

-- Métodos de pago más usados
SELECT
    mp.tipo,
    COUNT(v.id_viaje) AS total_usos,
    ROUND(COALESCE(SUM(v.importe_final), 0), 2) AS importe_total
FROM metodo_pago mp
LEFT JOIN viaje v ON mp.id_metodo_pago = v.id_metodo_pago
GROUP BY mp.tipo
ORDER BY total_usos DESC, importe_total DESC;

-- Uso de métodos de pago por usuario
SELECT
    u.id_usuario,
    CONCAT(u.nombre, ' ', u.apellidos) AS usuario,
    mp.tipo,
    COUNT(v.id_viaje) AS total_viajes
FROM metodo_pago mp
JOIN usuario u ON mp.id_usuario = u.id_usuario
LEFT JOIN viaje v ON mp.id_metodo_pago = v.id_metodo_pago
GROUP BY u.id_usuario, u.nombre, u.apellidos, mp.tipo
ORDER BY total_viajes DESC, usuario ASC;

-- Media de calificación recibida por conductor
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
ORDER BY media_puntuacion DESC, total_valoraciones DESC;

-- Media de calificación recibida por rider
SELECT
    r.id_usuario AS id_rider,
    CONCAT(u.nombre, ' ', u.apellidos) AS rider,
    ROUND(AVG(c.puntuacion), 2) AS media_puntuacion,
    COUNT(c.id_calificacion) AS total_valoraciones
FROM rider r
JOIN usuario u ON r.id_usuario = u.id_usuario
LEFT JOIN calificacion c
    ON r.id_usuario = c.id_receptor
   AND c.rol_receptor = 'RIDER'
GROUP BY r.id_usuario, u.nombre, u.apellidos
ORDER BY media_puntuacion DESC, total_valoraciones DESC;

-- Top conductores por número de viajes finalizados
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

-- Top companies por ingresos
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

-- Ajustes de tarifa por tipo
SELECT
    t.codigo,
    t.nombre,
    COUNT(a.id_ajuste) AS total_ajustes,
    ROUND(COALESCE(SUM(a.importe_ajuste), 0), 2) AS impacto_total
FROM tipo_ajuste_tarifa t
LEFT JOIN ajuste_tarifa a ON t.id_tipo_ajuste = a.id_tipo_ajuste
GROUP BY t.id_tipo_ajuste, t.codigo, t.nombre
ORDER BY total_ajustes DESC, impacto_total DESC;

-- Incidencias por tipo
SELECT
    tipo_incidencia,
    COUNT(*) AS total_incidencias
FROM incidencia
GROUP BY tipo_incidencia
ORDER BY total_incidencias DESC;

-- Incidencias por estado
SELECT
    estado_incidencia,
    COUNT(*) AS total_incidencias
FROM incidencia
GROUP BY estado_incidencia
ORDER BY total_incidencias DESC;

-- Incidencias por usuario que reporta
SELECT
    u.id_usuario,
    CONCAT(u.nombre, ' ', u.apellidos) AS usuario,
    COUNT(i.id_incidencia) AS incidencias_reportadas
FROM usuario u
LEFT JOIN incidencia i ON u.id_usuario = i.id_usuario_reporta
GROUP BY u.id_usuario, u.nombre, u.apellidos
ORDER BY incidencias_reportadas DESC, usuario ASC;

-- Vista de viajes finalizados para explotación
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
    mp.tipo AS metodo_pago,
    d.id_usuario AS id_driver,
    CONCAT(u.nombre, ' ', u.apellidos) AS driver,
    c.id_company,
    c.nombre AS company
FROM viaje v
LEFT JOIN metodo_pago mp ON v.id_metodo_pago = mp.id_metodo_pago
LEFT JOIN driver d ON v.id_driver_asignado = d.id_usuario
LEFT JOIN usuario u ON d.id_usuario = u.id_usuario
LEFT JOIN company c ON d.id_company = c.id_company
WHERE v.estado = 'FINALIZADO';

-- Vista de ofertas
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

-- Vista de incidencias
CREATE OR REPLACE VIEW v_dashboard_incidencias AS
SELECT
    i.id_incidencia,
    i.id_viaje,
    i.tipo_incidencia,
    i.estado_incidencia,
    CONCAT(u.nombre, ' ', u.apellidos) AS reportada_por,
    i.fecha_reporte,
    i.fecha_resolucion
FROM incidencia i
JOIN usuario u ON i.id_usuario_reporta = u.id_usuario;

-- Número de tablas
SELECT
    table_schema,
    COUNT(*) AS total_tablas
FROM information_schema.tables
WHERE table_schema = 'ride_hailing'
GROUP BY table_schema;

-- Tamaño de tablas
SELECT
    table_name,
    ROUND(data_length / 1024 / 1024, 2) AS datos_mb,
    ROUND(index_length / 1024 / 1024, 2) AS indices_mb,
    ROUND((data_length + index_length) / 1024 / 1024, 2) AS total_mb
FROM information_schema.tables
WHERE table_schema = 'ride_hailing'
ORDER BY total_mb DESC;

-- Estado general de conexiones
SHOW STATUS LIKE 'Threads_connected';
SHOW STATUS LIKE 'Connections';
SHOW VARIABLES LIKE 'max_connections';

-- Uptime del servidor
SHOW STATUS LIKE 'Uptime';

-- Configuración de slow queries
SHOW VARIABLES LIKE 'slow_query_log%';
SHOW VARIABLES LIKE 'long_query_time';

-- Procesos activos
SHOW PROCESSLIST;

-- Estadísticas globales de viajes
SELECT
    COUNT(*) AS total_viajes,
    SUM(CASE WHEN estado = 'FINALIZADO' THEN 1 ELSE 0 END) AS viajes_finalizados,
    SUM(CASE WHEN estado = 'CANCELADO' THEN 1 ELSE 0 END) AS viajes_cancelados,
    SUM(CASE WHEN estado = 'EN_CURSO' THEN 1 ELSE 0 END) AS viajes_en_curso,
    SUM(CASE WHEN estado = 'SOLICITADO' THEN 1 ELSE 0 END) AS viajes_solicitados
FROM viaje;

-- Estadísticas globales de ofertas
SELECT
    COUNT(*) AS total_ofertas,
    SUM(CASE WHEN estado_oferta = 'ACEPTADA' THEN 1 ELSE 0 END) AS ofertas_aceptadas,
    SUM(CASE WHEN estado_oferta = 'RECHAZADA' THEN 1 ELSE 0 END) AS ofertas_rechazadas,
    SUM(CASE WHEN estado_oferta = 'PENDIENTE' THEN 1 ELSE 0 END) AS ofertas_pendientes
FROM oferta;

-- Estadísticas globales de incidencias
SELECT
    COUNT(*) AS total_incidencias,
    SUM(CASE WHEN estado_incidencia = 'ABIERTA' THEN 1 ELSE 0 END) AS incidencias_abiertas,
    SUM(CASE WHEN estado_incidencia = 'EN_REVISION' THEN 1 ELSE 0 END) AS incidencias_en_revision,
    SUM(CASE WHEN estado_incidencia = 'RESUELTA' THEN 1 ELSE 0 END) AS incidencias_resueltas,
    SUM(CASE WHEN estado_incidencia = 'CERRADA' THEN 1 ELSE 0 END) AS incidencias_cerradas
FROM incidencia;

-- Vistas adicionales de dashboard de negocio

CREATE OR REPLACE VIEW v_dashboard_viajes_por_estado AS
SELECT 
    estado,
    COUNT(*) AS total_viajes
FROM viaje
GROUP BY estado;


CREATE OR REPLACE VIEW v_dashboard_viajes_por_hora AS
SELECT 
    DATE(fecha_solicitud) AS fecha,
    HOUR(fecha_solicitud) AS hora,
    COUNT(*) AS total_viajes
FROM viaje
GROUP BY DATE(fecha_solicitud), HOUR(fecha_solicitud)
ORDER BY fecha, hora;


CREATE OR REPLACE VIEW v_dashboard_ingresos_driver AS
SELECT
    d.id_usuario AS id_driver,
    CONCAT(u.nombre, ' ', u.apellidos) AS driver,
    c.id_company,
    c.nombre AS company,
    COUNT(v.id_viaje) AS viajes_finalizados,
    COALESCE(ROUND(SUM(v.importe_final), 2), 0) AS ingresos_total,
    COALESCE(ROUND(AVG(v.importe_final), 2), 0) AS ingreso_medio_viaje,
    COALESCE(ROUND(AVG(v.distancia_km), 2), 0) AS km_medio,
    COALESCE(ROUND(AVG(v.duracion_min), 2), 0) AS duracion_media_min,
    COALESCE(ROUND(SUM(v.importe_final) / NULLIF(SUM(v.distancia_km), 0), 2), 0) AS euros_por_km,
    COALESCE(ROUND(SUM(v.importe_final) / NULLIF(SUM(v.duracion_min), 0), 2), 0) AS euros_por_minuto
FROM driver d
JOIN usuario u ON d.id_usuario = u.id_usuario
JOIN company c ON d.id_company = c.id_company
LEFT JOIN viaje v 
    ON d.id_usuario = v.id_driver_asignado
   AND v.estado = 'FINALIZADO'
GROUP BY d.id_usuario, u.nombre, u.apellidos, c.id_company, c.nombre;


CREATE OR REPLACE VIEW v_dashboard_ingresos_company AS
SELECT
    c.id_company,
    c.nombre AS company,
    COUNT(v.id_viaje) AS viajes_finalizados,
    COALESCE(ROUND(SUM(v.importe_final), 2), 0) AS ingresos_total,
    COALESCE(ROUND(AVG(v.importe_final), 2), 0) AS ingreso_medio_viaje,
    COALESCE(ROUND(AVG(v.distancia_km), 2), 0) AS km_medio,
    COALESCE(ROUND(AVG(v.duracion_min), 2), 0) AS duracion_media_min,
    COALESCE(ROUND(SUM(v.importe_final) / NULLIF(SUM(v.distancia_km), 0), 2), 0) AS euros_por_km,
    COALESCE(ROUND(SUM(v.importe_final) / NULLIF(SUM(v.duracion_min), 0), 2), 0) AS euros_por_minuto
FROM company c
LEFT JOIN driver d ON c.id_company = d.id_company
LEFT JOIN viaje v 
    ON d.id_usuario = v.id_driver_asignado
   AND v.estado = 'FINALIZADO'
GROUP BY c.id_company, c.nombre;


CREATE OR REPLACE VIEW v_dashboard_aceptacion_driver AS
SELECT
    d.id_usuario AS id_driver,
    CONCAT(u.nombre, ' ', u.apellidos) AS driver,
    c.nombre AS company,
    COUNT(o.id_oferta) AS ofertas_recibidas,
    COALESCE(SUM(o.estado_oferta = 'ACEPTADA'), 0) AS ofertas_aceptadas,
    COALESCE(SUM(o.estado_oferta = 'RECHAZADA'), 0) AS ofertas_rechazadas,
    COALESCE(SUM(o.estado_oferta = 'PENDIENTE'), 0) AS ofertas_pendientes,
    COALESCE(
        ROUND(
            100 * SUM(o.estado_oferta = 'ACEPTADA') / NULLIF(COUNT(o.id_oferta), 0),
            2
        ),
        0
    ) AS tasa_aceptacion_pct
FROM driver d
JOIN usuario u ON d.id_usuario = u.id_usuario
JOIN company c ON d.id_company = c.id_company
LEFT JOIN oferta o ON d.id_usuario = o.id_driver
GROUP BY d.id_usuario, u.nombre, u.apellidos, c.nombre;


CREATE OR REPLACE VIEW v_dashboard_aceptacion_company AS
SELECT
    c.id_company,
    c.nombre AS company,
    COUNT(o.id_oferta) AS ofertas_recibidas,
    COALESCE(SUM(o.estado_oferta = 'ACEPTADA'), 0) AS ofertas_aceptadas,
    COALESCE(SUM(o.estado_oferta = 'RECHAZADA'), 0) AS ofertas_rechazadas,
    COALESCE(SUM(o.estado_oferta = 'PENDIENTE'), 0) AS ofertas_pendientes,
    COALESCE(
        ROUND(
            100 * SUM(o.estado_oferta = 'ACEPTADA') / NULLIF(COUNT(o.id_oferta), 0),
            2
        ),
        0
    ) AS tasa_aceptacion_pct
FROM company c
LEFT JOIN driver d ON c.id_company = d.id_company
LEFT JOIN oferta o ON d.id_usuario = o.id_driver
GROUP BY c.id_company, c.nombre;


CREATE OR REPLACE VIEW v_dashboard_resumen_negocio AS
SELECT
    COUNT(*) AS total_viajes,
    SUM(estado = 'FINALIZADO') AS viajes_finalizados,
    SUM(estado = 'CANCELADO') AS viajes_cancelados,
    SUM(estado = 'SOLICITADO') AS viajes_solicitados,
    SUM(estado = 'ACEPTADO') AS viajes_aceptados,
    SUM(estado = 'EN_CURSO') AS viajes_en_curso,
    ROUND(AVG(CASE WHEN estado = 'FINALIZADO' THEN distancia_km END), 2) AS km_medio_finalizados,
    ROUND(AVG(CASE WHEN estado = 'FINALIZADO' THEN duracion_min END), 2) AS duracion_media_finalizados,
    ROUND(SUM(CASE WHEN estado = 'FINALIZADO' THEN importe_final ELSE 0 END), 2) AS ingresos_finalizados
FROM viaje;