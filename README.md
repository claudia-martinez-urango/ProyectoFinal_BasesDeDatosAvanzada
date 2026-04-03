# ProyectoFinal_BasesDeDatosAvanzada
- LINK AL MER: https://lucid.app/lucidchart/4d59a050-775c-43a4-a0a0-888e4b221faa/edit?viewport_loc=-1437%2C-2942%2C4270%2C1714%2C0_0&invitationId=inv_092f7be8-5e4a-4ace-a517-d87ea7d2f8ad

# 🚗 Ride Hailing Database Project

## 📌 Descripción

Este proyecto consiste en el diseño e implementación de una base de datos relacional para una plataforma de ride-hailing (tipo Uber, Bolt o Lyft).

Permite gestionar:

* Usuarios (riders y conductores)
* Empresas (companies)
* Vehículos
* Viajes
* Ofertas a conductores
* Ajustes de tarifa
* Auditoría del sistema

---

## ⚙️ Tecnologías utilizadas

* MySQL 8
* Docker & Docker Compose
* SQL (DDL, DML, transacciones, joins, locks)

---

## 📂 Estructura del proyecto

```
ProyectoFinal_BDA/
│── schema.sql          # Creación de la base de datos
│── data.sql            # Datos de prueba
│── queries.sql         # Operativa del sistema
│── dashboard.sql       # Métricas de negocio y BD
│── backup.sql          # Plan de backup y recuperación
│── permissions.sql     # Usuarios y permisos
│── docker-compose.yml  # Despliegue con Docker
│── README.md           # Instrucciones
│── DESIGN.md           # Diseño y MER
```

---

## 🚀 Cómo ejecutar el proyecto

### 1. Requisitos

* Docker Desktop instalado

---

### 2. Levantar la base de datos

```bash
docker compose up -d
```

Esto:

* crea el contenedor MySQL
* crea la base de datos `ride_hailing`
* ejecuta automáticamente:

  * `schema.sql`
  * `data.sql`

---

### 3. Comprobar que está funcionando

```bash
docker ps
```

---

### 4. Conectarse a la base de datos

```bash
docker exec -it mysql_ride_hailing_PRACTICA mysql -uroot -proot_password
```

---

### 5. Probar consultas

```sql
USE ride_hailing;

SELECT * FROM viaje;
SELECT * FROM oferta;
SELECT * FROM ajuste_tarifa;
```

---

## 📊 Funcionalidades implementadas

### ✔️ Operativa

* Creación de viajes
* Envío de ofertas a múltiples conductores
* Aceptación del primer conductor (control de concurrencia)
* Ajustes de tarifa
* Auditoría de eventos

### ✔️ Consultas

* Joins complejos
* Transacciones
* Locks (`FOR UPDATE`) para evitar conflictos

### ✔️ Dashboard

* Tasa de aceptación
* Ingresos por conductor y company
* Tiempo y distancia media
* Viajes por hora

### ✔️ Seguridad

* Usuarios con roles diferenciados
* Principio de mínimo privilegio

### ✔️ Backup

* Estrategia de copias de seguridad
* Restauración de datos

---

## 🔒 Seguridad

Se han definido distintos roles:

* `admin_app` → control total
* `operator_app` → operativa del sistema
* `analyst_app` → consultas y dashboard
* `backup_user` → copias de seguridad
* `readonly_user` → solo lectura

---

## 💾 Backup y recuperación

Se utilizan:

* backups completos (`mysqldump`)
* backups parciales
* estrategia de retención
* restauración desde archivo

---

## 🧠 Diseño

El diseño sigue un modelo relacional con:

* especialización de usuarios (driver / rider)
* relaciones N:M (driver-vehículo)
* control de concurrencia en viajes
* auditoría genérica

Ver más en: `DESIGN.md`

---

## 👥 Autores

* Claudia Martínez Urango
* Mónica López Ucha 
* Cristina Fernández Gomariz

---

## 📌 Notas

* El sistema garantiza que solo un conductor puede aceptar un viaje mediante locks.
* Se ha priorizado consistencia y escalabilidad en el diseño.
* Preparado para ampliaciones futuras (pagos, ratings, etc.).

---
