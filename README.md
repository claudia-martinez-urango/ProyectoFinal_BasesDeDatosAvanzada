# ProyectoFinal_BasesDeDatosAvanzada
- LINK AL MER: https://lucid.app/lucidchart/4d59a050-775c-43a4-a0a0-888e4b221faa/edit?viewport_loc=-1437%2C-2942%2C4270%2C1714%2C0_0&invitationId=inv_092f7be8-5e4a-4ace-a517-d87ea7d2f8ad

# 🚖 Ride Hailing - Base de Datos Avanzada

Proyecto de diseño e implementación de una base de datos para una plataforma de transporte bajo demanda similar a Uber o Cabify.

---

## 📌 Descripción

En esta práctica se ha desarrollado una base de datos que permite gestionar todo el ciclo de un viaje:

- solicitud por parte del usuario  
- envío de ofertas a conductores  
- asignación del conductor  
- realización del trayecto  
- cálculo del importe final  
- registro de incidencias y valoraciones  

Además, se han añadido funcionalidades adicionales para acercar el modelo a un caso real, como métodos de pago, auditoría y métricas de análisis.

---

## 🧱 Estructura del proyecto

El proyecto está organizado en varios archivos SQL y documentación:

- `schema.sql` → creación de la base de datos, tablas e índices  
- `data.sql` → datos de prueba  
- `queries.sql` → consultas operativas (inserts, updates, transacciones…)  
- `dashboard.sql` → consultas analíticas y métricas  
- `permissions.sql` → gestión de usuarios y permisos  
- `backup.sql` → estrategia de copias de seguridad  
- `DESIGN.md` → explicación del diseño  

---

## 🗄️ Modelo de datos

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

## ⚙️ Puesta en marcha

### 1. Levantar la base de datos

```bash
docker compose up -d