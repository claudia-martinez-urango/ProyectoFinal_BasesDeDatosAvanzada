# ProyectoFinal_BasesDeDatosAvanzada
- LINK AL MER: https://lucid.app/lucidchart/4d59a050-775c-43a4-a0a0-888e4b221faa/edit?viewport_loc=-1437%2C-2942%2C4270%2C1714%2C0_0&invitationId=inv_092f7be8-5e4a-4ace-a517-d87ea7d2f8ad

# 🚖 Ride Hailing - Base de Datos Avanzada

Proyecto de diseño e implementación de una base de datos para una plataforma de transporte bajo demanda similar a Uber o Cabify.

---

## 📌 1. Descripción del proyecto

El objetivo de esta práctica es desarrollar una base de datos que permita gestionar todo el ciclo de vida de un viaje:

1. Un usuario solicita un viaje  
2. Se envía a varios conductores  
3. Un conductor acepta la oferta  
4. Se realiza el trayecto  
5. Se calcula el importe final  
6. Se registran incidencias (si las hay)  
7. Se realizan valoraciones  

Además, se han añadido funcionalidades adicionales para acercar el modelo a un caso real, como métodos de pago, auditoría y métricas de análisis.
---
## 🎯 2. Objetivos

- Diseñar un modelo relacional completo  
- Garantizar integridad y consistencia  
- Implementar consultas operativas  
- Desarrollar métricas analíticas  
- Aplicar seguridad mediante roles  
- Definir una estrategia de backup  

---

## 🧱 3. Estructura del proyecto

El proyecto está organizado en varios archivos SQL y documentación:

- `schema.sql` → creación de la base de datos, tablas e índices  
- `data.sql` → datos de prueba  
- `queries.sql` → consultas operativas (inserts, updates, transacciones…)  
- `dashboard.sql` → consultas analíticas y métricas  
- `permissions.sql` → gestión de usuarios y permisos  
- `backup.sql` → estrategia de copias de seguridad  
- `DESIGN.md` → explicación del diseño  

---

## 🗄️ 4. Modelo de datos

La base de datos se organiza alrededor de la tabla **VIAJE**, que conecta con el resto de entidades:

- `usuario` → información común  
- `driver` y `rider` → roles  
- `company` → empresa del conductor  
- `vehiculo` → coches disponibles  
- `oferta` → asignación de viajes  
- `ajuste_tarifa` → cambios en el precio  
- `metodo_pago` → forma de pago  
- `calificacion` → valoraciones  
- `incidencia` → problemas durante el servicio  
- `auditoria_evento` → registro de acciones  

El modelo permite reconstruir completamente lo que ocurre en cada viaje.

---
## 🔄 5. Flujo del sistema

1. El rider solicita un viaje  
2. Se generan ofertas para conductores  
3. Un conductor acepta  
4. Se asigna el viaje  
5. Se realiza el trayecto  
6. Se aplican ajustes  
7. Se registra el pago  
8. Se registran incidencias  
9. Se realizan valoraciones  
---
## ⚙️ 6. Puesta en marcha
### Levantar entorno

```bash
docker compose up -d
docker exec -it mysql_ride_hailing_PRACTICA mysql -u root -p
USE ride_hailing;
```

---

## 📊 7. Consultas operativas

En `queries.sql` se incluyen ejemplos de:

- creación de viajes  
- envío de ofertas  
- aceptación de viajes  
- registro de incidencias  
- inserción de calificaciones  
- ajustes de tarifa  
- transacciones  
- control de concurrencia  

---
## 📈 8. Dashboard

En `dashboard.sql` se incluyen métricas como:

- tasa de aceptación  
- ingresos por conductor y empresa  
- uso de métodos de pago  
- media de valoraciones  
- incidencias por tipo y estado  
- distribución de viajes  

---
## 🔐 9. Seguridad

| Usuario        | Rol                |
|---------------|--------------------|
| admin_app     | control total      |
| operador_app  | operativa diaria   |
| analista_app  | solo lectura       |
| backup_app    | copias de seguridad|
| consulta_app  | consultas básicas  |

Se aplica el principio de mínimo privilegio.
---
## 💾 10. Copias de seguridad

- copia completa diaria  
- copias parciales  
- restauración desde fichero  
- uso de Docker  

---
## 🧠 11. Decisiones de diseño

- separación usuario / driver / rider  
- relación N:M conductor-vehículo  
- normalización de ajustes  
- método de pago independiente  
- incidencias y valoraciones  
- auditoría  

Más detalle en `DESIGN.md`.
---
## 🚀 12. Mejoras añadidas

- sistema de valoraciones  
- incidencias  
- métodos de pago  
- auditoría  
- dashboard analítico  

---
## 🚀 12. Mejoras añadidas

- sistema de valoraciones  
- incidencias  
- métodos de pago  
- auditoría  
- dashboard analítico  

---
## ⚡ 13. Rendimiento

- índices en claves foráneas  
- optimización de joins  
- consultas para análisis  

---
## 🔍 14. Integridad

- claves primarias y foráneas  
- restricciones CHECK  
- control de estados  
- uso de transacciones  

---
## 🧪 15. Pruebas realizadas

- inserción de datos  
- ejecución de consultas  
- validación de relaciones  
- pruebas de concurrencia  
- comprobación de métricas  

---
## 📌 16. Posibles mejoras futuras

- geolocalización  
- rutas  
- pricing dinámico  
- historial de pagos  
- APIs externas  

---
## ✅ 17. Estado del proyecto

✔ Modelo completo  
✔ Datos de prueba  
✔ Consultas  
✔ Dashboard  
✔ Seguridad  
✔ Backups  

---
## 📎 18. Conclusión

El sistema permite gestionar de forma completa una plataforma de ride-hailing, combinando operativa, análisis y seguridad en una misma base de datos.

Se ha buscado un equilibrio entre cumplir los requisitos y diseñar un sistema realista.