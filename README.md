# ProyectoFinal_BasesDeDatosAvanzada

- LINK AL MER: https://lucid.app/lucidchart/4d59a050-775c-43a4-a0a0-888e4b221faa/edit?viewport_loc=-1437%2C-2942%2C4270%2C1714%2C0_0&invitationId=inv_092f7be8-5e4a-4ace-a517-d87ea7d2f8ad

# 🚖 Ride Hailing - Base de Datos Avanzada

Proyecto de diseño e implementación de una base de datos para una plataforma de transporte bajo demanda similar a Uber, Bolt, Lyft o Cabify.

---

## 📌 1. Descripción del proyecto

El objetivo de esta práctica es desarrollar una base de datos que permita gestionar todo el ciclo de vida de un viaje:

1. Un usuario solicita un viaje.
2. Se envía una oferta a varios conductores.
3. Un conductor acepta la oferta.
4. Se asigna el viaje al conductor.
5. Se realiza el trayecto.
6. Se calcula el importe final.
7. Se registran incidencias, si las hay.
8. Se realizan valoraciones entre rider y conductor.

Además, se han añadido funcionalidades adicionales para acercar el modelo a un caso real, como métodos de pago, auditoría, procedimientos almacenados, backups, métricas analíticas y monitorización técnica con Prometheus y Grafana.

---

## 🎯 2. Objetivos

- Diseñar un modelo relacional completo.
- Garantizar integridad y consistencia.
- Implementar consultas operativas.
- Desarrollar métricas analíticas.
- Aplicar seguridad mediante usuarios y permisos.
- Definir una estrategia de backup y recuperación.
- Usar Docker y Docker Compose para el despliegue.
- Añadir monitorización técnica de la base de datos.

---

## 🧱 3. Estructura del proyecto

El proyecto está organizado en varios archivos SQL, documentación y configuración Docker:

- `schema.sql` → creación de la base de datos, tablas, claves, restricciones, índices y triggers.
- `data.sql` → carga de datos de prueba.
- `queries.sql` → consultas operativas, inserts, updates, joins, transacciones y concurrencia.
- `dashboard.sql` → consultas analíticas y métricas de negocio/base de datos.
- `procedures.sql` → procedimientos almacenados para operaciones reutilizables.
- `permissions.sql` → creación de usuarios y asignación de permisos.
- `backup.sql` → estrategia de copias de seguridad y restauración.
- `compose.yml` → despliegue con Docker Compose.
- `README.md` → instrucciones de ejecución.
- `DESIGN.md` → explicación del diseño de la base de datos.
- `monitoring/` → configuración de Prometheus, Grafana y MySQL Exporter.
- `backups/` → carpeta local para almacenar backups generados con `mysqldump`.

---

## 🗄️ 4. Modelo de datos

La base de datos se organiza alrededor de la tabla `viaje`, que conecta con el resto de entidades:

- `usuario` → información común de personas.
- `rider` → usuarios que solicitan viajes.
- `driver` → usuarios que conducen.
- `company` → empresa a la que pertenece cada conductor.
- `vehiculo` → vehículos disponibles.
- `driver_vehiculo` → relación entre conductores y vehículos.
- `viaje` → trayectos solicitados por riders.
- `oferta` → ofertas enviadas a conductores para aceptar o rechazar viajes.
- `metodo_pago` → forma de pago asociada al usuario.
- `tipo_ajuste_tarifa` → catálogo de tipos de ajuste.
- `ajuste_tarifa` → cambios aplicados al importe final del viaje.
- `calificacion` → valoraciones entre rider y driver.
- `incidencia` → problemas durante el servicio.
- `auditoria_evento` → registro de operaciones relevantes.

El modelo permite reconstruir completamente lo que ocurre en cada viaje.

---

## 🔄 5. Flujo del sistema

1. El rider solicita un viaje.
2. Se crea un registro en `viaje` con estado `SOLICITADO`.
3. Se generan ofertas para varios conductores.
4. Un conductor acepta la oferta.
5. El sistema asigna el conductor al viaje.
6. El viaje pasa a estado `ACEPTADO`.
7. Las demás ofertas del mismo viaje pasan a `RECHAZADA`.
8. El viaje puede pasar a `EN_CURSO`.
9. Finalmente pasa a `FINALIZADO` o `CANCELADO`.
10. Se aplican ajustes de tarifa si corresponde.
11. Se registran incidencias si las hay.
12. Se insertan calificaciones.
13. Se registran eventos de auditoría.

---

## ⚙️ 6. Puesta en marcha

### Levantar el entorno

Desde la raíz del proyecto:

```bash
docker compose up -d
```

Comprobar que los contenedores están activos:

```bash
docker ps
```

Deberían aparecer, entre otros:

```text
mysql_ride_hailing_PRACTICA
mysql_exporter_ride_hailing
prometheus_ride_hailing
grafana_ride_hailing
```

---

### Entrar a MySQL

```bash
docker exec -it mysql_ride_hailing_PRACTICA mysql -u root -p
```

Contraseña:

```text
root_password
```

Dentro de MySQL:

```sql
USE ride_hailing;
SHOW TABLES;
```

Comprobación básica:

```sql
SELECT COUNT(*) FROM usuario;
SELECT COUNT(*) FROM viaje;
SELECT COUNT(*) FROM oferta;
```

---

## 📊 7. Consultas operativas

En `queries.sql` se incluyen ejemplos de:

- creación de viajes.
- envío de ofertas.
- aceptación de viajes.
- actualización de estados.
- registro de incidencias.
- inserción de calificaciones.
- ajustes de tarifa.
- consultas con joins.
- transacciones.
- control de concurrencia con `FOR UPDATE`.

Ejecutar:

```powershell
cmd /c "docker exec -i mysql_ride_hailing_PRACTICA mysql -uroot -proot_password ride_hailing < queries.sql"
```

---

## ⚙️ 8. Procedimientos almacenados

El proyecto incluye `procedures.sql`, que define procedimientos almacenados para encapsular operaciones habituales del sistema.

Procedimientos incluidos:

- `sp_crear_viaje`
- `sp_enviar_oferta`
- `sp_aceptar_oferta`
- `sp_finalizar_viaje`
- `sp_registrar_incidencia`

Estos procedimientos permiten reutilizar lógica de negocio dentro de MySQL.

Por ejemplo, `sp_aceptar_oferta` se encarga de:

1. Bloquear la oferta.
2. Bloquear el viaje con `FOR UPDATE`.
3. Comprobar que la oferta está pendiente.
4. Comprobar que el viaje sigue en estado `SOLICITADO`.
5. Aceptar una oferta.
6. Rechazar el resto de ofertas del mismo viaje.
7. Asignar el conductor al viaje.
8. Registrar auditoría.
9. Confirmar la transacción.

Cargar manualmente los procedimientos:

```powershell
cmd /c "docker exec -i mysql_ride_hailing_PRACTICA mysql -uroot -proot_password ride_hailing < procedures.sql"
```

Comprobar que existen:

```powershell
docker exec mysql_ride_hailing_PRACTICA mysql -uroot -proot_password ride_hailing -e "SHOW PROCEDURE STATUS WHERE Db = 'ride_hailing';"
```

Ejemplo de uso:

```sql
CALL sp_crear_viaje(
    16,
    12,
    40.4167750,
    -3.7037900,
    'Puerta del Sol, Madrid',
    40.4300000,
    -3.7000000,
    'Bilbao, Madrid',
    9.80
);
```

---

## 📈 9. Dashboard SQL

En `dashboard.sql` se incluyen métricas de negocio y de base de datos.

Métricas principales:

- tasa de aceptación por conductor.
- tasa de aceptación por empresa.
- ingresos por conductor.
- ingresos por empresa.
- euros por kilómetro.
- euros por minuto.
- uso de métodos de pago.
- media de valoraciones.
- incidencias por tipo y estado.
- distribución de viajes por estado.
- distribución de viajes por hora.
- tamaño de tablas.
- conexiones activas.
- consultas lentas.
- estado del servidor MySQL.

Ejecutar:

```powershell
cmd /c "docker exec -i mysql_ride_hailing_PRACTICA mysql -uroot -proot_password ride_hailing < dashboard.sql"
```

---

## 📡 10. Monitorización con Prometheus y Grafana

Además del dashboard SQL, el proyecto incluye una capa de monitorización técnica con Prometheus y Grafana.

Arquitectura:

```text
MySQL → MySQL Exporter → Prometheus → Grafana
```

### Servicios

| Servicio | URL |
|---|---|
| MySQL Exporter | http://localhost:9104/metrics |
| Prometheus | http://localhost:9090 |
| Grafana | http://localhost:3000 |

Credenciales de Grafana:

```text
Usuario: admin
Contraseña: admin
```

### Métricas útiles

Algunas métricas que se pueden consultar en Prometheus o Grafana:

```text
mysql_up
mysql_global_status_threads_connected
mysql_global_status_questions
mysql_global_status_slow_queries
mysql_global_variables_max_connections
mysql_global_status_uptime
```

### Comprobación en Prometheus

Abrir:

```text
http://localhost:9090/targets
```

Los targets `mysql` y `prometheus` deberían aparecer como `UP`.

También se puede consultar:

```text
mysql_up
```

Resultado esperado:

```text
1
```

### Comprobación en Grafana

Abrir:

```text
http://localhost:3000
```

Entrar con:

```text
admin / admin
```

Ir a:

```text
Explore → Prometheus
```

Consultar:

```text
mysql_up
```

Si devuelve `1`, Grafana está leyendo correctamente las métricas de Prometheus.

### Valor que aporta

`dashboard.sql` permite analizar el negocio: viajes, ingresos, ofertas, incidencias y valoraciones.

Prometheus y Grafana permiten monitorizar la salud técnica de MySQL:

- si la base de datos está activa.
- cuántas conexiones hay.
- cuántas consultas se ejecutan.
- si aparecen consultas lentas.
- cuánto tiempo lleva funcionando el servidor.

---

## 🔐 11. Seguridad

El proyecto define varios usuarios de base de datos con distintos permisos:

| Usuario | Rol |
|---|---|
| `admin_app` | control total |
| `operador_app` | operativa diaria |
| `analista_app` | solo lectura y análisis |
| `backup_app` | copias de seguridad |
| `consulta_app` | consultas básicas |
| `exporter` | monitorización técnica |

Se aplica el principio de mínimo privilegio: cada usuario solo tiene los permisos necesarios para su función.

Ejecutar permisos:

```powershell
cmd /c "docker exec -i mysql_ride_hailing_PRACTICA mysql -uroot -proot_password ride_hailing < permissions.sql"
```

El usuario `operador_app` también tiene permisos `EXECUTE` sobre los procedimientos almacenados operativos.

---

## 💾 12. Copias de seguridad

El proyecto incluye una estrategia de backup y recuperación mediante `mysqldump`.

Se ha añadido una carpeta local de backups montada en el contenedor:

```yaml
./backups:/backups
```

Esto permite que los backups generados dentro del contenedor queden guardados en el host.

### Crear backup completo

```powershell
docker exec mysql_ride_hailing_PRACTICA sh -c "mysqldump -uroot -proot_password --single-transaction --routines --triggers --events ride_hailing > /backups/ride_hailing_backup.sql"
```

El fichero aparecerá en:

```text
./backups/ride_hailing_backup.sql
```

### Restauración de prueba

Crear una base de restauración:

```powershell
docker exec mysql_ride_hailing_PRACTICA mysql -uroot -proot_password -e "DROP DATABASE IF EXISTS ride_hailing_restore; CREATE DATABASE ride_hailing_restore;"
```

Restaurar backup:

```powershell
docker exec mysql_ride_hailing_PRACTICA sh -c "mysql -uroot -proot_password ride_hailing_restore < /backups/ride_hailing_backup.sql"
```

Comprobar datos restaurados:

```powershell
docker exec mysql_ride_hailing_PRACTICA mysql -uroot -proot_password -e "SELECT COUNT(*) AS viajes FROM ride_hailing_restore.viaje; SELECT COUNT(*) AS ofertas FROM ride_hailing_restore.oferta; SELECT COUNT(*) AS usuarios FROM ride_hailing_restore.usuario;"
```

Comprobar que se restauró el índice avanzado:

```powershell
docker exec mysql_ride_hailing_PRACTICA mysql -uroot -proot_password -e "SHOW INDEX FROM ride_hailing_restore.oferta WHERE Key_name = 'uq_oferta_aceptada_por_viaje';"
```

Eliminar la base de prueba:

```powershell
docker exec mysql_ride_hailing_PRACTICA mysql -uroot -proot_password -e "DROP DATABASE ride_hailing_restore;"
```

---

## 🧠 13. Decisiones de diseño

Principales decisiones:

- separación entre `usuario`, `rider` y `driver`.
- relación entre `driver` y `company`.
- relación N:M entre conductor y vehículo mediante `driver_vehiculo`.
- tabla `viaje` como centro del modelo.
- tabla `oferta` para gestionar la aceptación/rechazo por parte de conductores.
- métodos de pago independientes.
- normalización de ajustes de tarifa.
- incidencias asociadas a viajes.
- calificaciones entre usuarios.
- auditoría de eventos importantes.
- índices para mejorar rendimiento.
- procedimientos almacenados para operaciones críticas.
- monitorización técnica con Prometheus y Grafana.
- backups persistidos fuera del contenedor.

Más detalle en `DESIGN.md`.

---

## 🚀 14. Mejoras añadidas

Además de los requisitos básicos, se han añadido:

- sistema de valoraciones.
- gestión de incidencias.
- métodos de pago.
- auditoría.
- dashboard analítico.
- procedimientos almacenados.
- control reforzado de una única oferta aceptada por viaje.
- volumen local para backups.
- validación real de restauración.
- monitorización con Prometheus y Grafana.
- usuario específico para métricas (`exporter`).

---

## ⚡ 15. Rendimiento

Se han añadido índices para mejorar consultas habituales:

- índices en claves foráneas.
- índices sobre estados.
- índices en relaciones usadas por joins.
- índice único para impedir más de una oferta aceptada por viaje.

Ejemplos:

- búsquedas de viajes por rider.
- búsquedas de viajes por driver.
- búsquedas de ofertas por viaje.
- búsquedas de incidencias por estado.
- métricas de dashboard.

---

## 🔍 16. Integridad

El proyecto garantiza integridad mediante:

- claves primarias.
- claves foráneas.
- restricciones `CHECK`.
- control de estados.
- transacciones.
- bloqueos `FOR UPDATE`.
- triggers.
- índice único para asegurar una única oferta aceptada por viaje.

La restricción avanzada más importante es:

```text
uq_oferta_aceptada_por_viaje
```

Esta impide que un mismo viaje tenga dos ofertas en estado `ACEPTADA`.

---

## 🧪 17. Pruebas realizadas

Se han realizado pruebas de:

- creación de tablas.
- carga de datos.
- ejecución de consultas operativas.
- dashboard SQL.
- usuarios y permisos.
- procedimientos almacenados.
- control de concurrencia.
- restricción de una única oferta aceptada.
- backups y restauración.
- monitorización Prometheus/Grafana.

Pruebas destacadas:

- `mysql_up = 1` en Prometheus y Grafana.
- restauración correcta en `ride_hailing_restore`.
- bloqueo de segunda oferta aceptada para el mismo viaje.
- ejecución correcta de `sp_crear_viaje`, `sp_enviar_oferta`, `sp_aceptar_oferta`, `sp_finalizar_viaje` y `sp_registrar_incidencia`.

---

## 📌 18. Posibles mejoras futuras

- geolocalización avanzada.
- cálculo real de rutas.
- pricing dinámico.
- historial completo de pagos.
- integración con APIs externas de mapas.
- alertas automáticas en Grafana.
- dashboards personalizados de negocio en Grafana.
- automatización periódica de backups.
- particionado de tablas históricas.

---

## ✅ 19. Estado del proyecto

✔ Modelo completo  
✔ Datos de prueba  
✔ Consultas operativas  
✔ Dashboard SQL  
✔ Seguridad y permisos  
✔ Backups  
✔ Restauración probada  
✔ Procedimientos almacenados  
✔ Control de concurrencia  
✔ Monitorización técnica  
✔ Docker Compose  

---

## 📎 20. Conclusión

El sistema permite gestionar de forma completa una plataforma de ride-hailing, combinando operativa, análisis, seguridad, copias de seguridad y monitorización técnica en una misma solución.

Se ha buscado un equilibrio entre cumplir los requisitos de la práctica y diseñar un sistema realista, mantenible y cercano a un entorno de producción.