-- MySQL dump 10.13  Distrib 8.0.46, for Linux (x86_64)
--
-- Host: localhost    Database: ride_hailing
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ajuste_tarifa`
--

DROP TABLE IF EXISTS `ajuste_tarifa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ajuste_tarifa` (
  `id_ajuste` bigint NOT NULL AUTO_INCREMENT,
  `id_viaje` bigint NOT NULL,
  `id_tipo_ajuste` bigint NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `importe_ajuste` decimal(10,2) NOT NULL,
  `fecha_ajuste` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_ajuste`),
  KEY `idx_ajuste_viaje` (`id_viaje`),
  KEY `idx_ajuste_tipo` (`id_tipo_ajuste`),
  CONSTRAINT `fk_ajuste_tipo` FOREIGN KEY (`id_tipo_ajuste`) REFERENCES `tipo_ajuste_tarifa` (`id_tipo_ajuste`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_ajuste_viaje` FOREIGN KEY (`id_viaje`) REFERENCES `viaje` (`id_viaje`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ajuste_tarifa`
--

LOCK TABLES `ajuste_tarifa` WRITE;
/*!40000 ALTER TABLE `ajuste_tarifa` DISABLE KEYS */;
INSERT INTO `ajuste_tarifa` VALUES (1,1,1,'El conductor esperÃ³ 5 minutos en la recogida',1.50,'2026-03-10 08:06:00'),(2,1,2,'Cambio de destino solicitado durante el trayecto',1.00,'2026-03-10 08:12:00'),(3,4,3,'Peaje urbano en la ruta',1.00,'2026-03-11 13:40:00'),(4,7,1,'Espera adicional en el punto de recogida',1.25,'2026-03-13 08:52:00'),(5,8,4,'Alta demanda en zona IFEMA',1.50,'2026-03-13 14:03:00'),(6,10,2,'Cambio de destino hacia una zona mÃ¡s alejada',2.00,'2026-03-14 21:20:00'),(7,13,5,'CupÃ³n promocional aplicado',-1.50,'2026-03-16 10:15:00'),(8,14,3,'Peaje de acceso rÃ¡pido',2.50,'2026-03-16 18:40:00');
/*!40000 ALTER TABLE `ajuste_tarifa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auditoria_evento`
--

DROP TABLE IF EXISTS `auditoria_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditoria_evento` (
  `id_auditoria` bigint NOT NULL AUTO_INCREMENT,
  `tabla_afectada` varchar(50) NOT NULL,
  `id_registro` bigint NOT NULL,
  `accion` varchar(20) NOT NULL,
  `detalle` varchar(255) DEFAULT NULL,
  `usuario_bd` varchar(100) NOT NULL,
  `fecha_evento` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_auditoria`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditoria_evento`
--

LOCK TABLES `auditoria_evento` WRITE;
/*!40000 ALTER TABLE `auditoria_evento` DISABLE KEYS */;
INSERT INTO `auditoria_evento` VALUES (1,'viaje',1,'INSERT','CreaciÃ³n del viaje 1','root@localhost','2026-03-10 08:00:00'),(2,'oferta',1,'UPDATE','Oferta aceptada por el driver 1','root@localhost','2026-03-10 08:01:00'),(3,'ajuste_tarifa',1,'INSERT','Ajuste por tiempo de espera','root@localhost','2026-03-10 08:06:00'),(4,'viaje',4,'INSERT','CreaciÃ³n del viaje 4','root@localhost','2026-03-11 13:30:00'),(5,'incidencia',1,'INSERT','Incidencia de limpieza registrada','root@localhost','2026-03-11 14:05:00'),(6,'viaje',6,'UPDATE','Viaje cancelado por el rider','root@localhost','2026-03-12 19:15:00'),(7,'calificacion',10,'INSERT','CalificaciÃ³n registrada por rider','root@localhost','2026-03-13 15:00:00'),(8,'viaje',10,'UPDATE','Importe final ajustado por cambio de destino','root@localhost','2026-03-14 21:20:00'),(9,'ajuste_tarifa',7,'INSERT','Descuento aplicado al viaje 13','root@localhost','2026-03-16 10:15:00'),(10,'incidencia',5,'INSERT','Incidencia en revisiÃ³n por retraso','root@localhost','2026-03-16 19:10:00'),(11,'incidencia',6,'INSERT','Objeto olvidado reportado','root@localhost','2026-03-17 13:10:00');
/*!40000 ALTER TABLE `auditoria_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `calificacion`
--

DROP TABLE IF EXISTS `calificacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `calificacion` (
  `id_calificacion` bigint NOT NULL AUTO_INCREMENT,
  `id_viaje` bigint NOT NULL,
  `id_emisor` bigint NOT NULL,
  `id_receptor` bigint NOT NULL,
  `rol_emisor` varchar(20) NOT NULL,
  `rol_receptor` varchar(20) NOT NULL,
  `puntuacion` int NOT NULL,
  `comentario` varchar(255) DEFAULT NULL,
  `fecha_calificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_calificacion`),
  KEY `idx_calificacion_viaje` (`id_viaje`),
  KEY `idx_calificacion_emisor` (`id_emisor`),
  KEY `idx_calificacion_receptor` (`id_receptor`),
  CONSTRAINT `fk_calificacion_emisor` FOREIGN KEY (`id_emisor`) REFERENCES `usuario` (`id_usuario`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_calificacion_receptor` FOREIGN KEY (`id_receptor`) REFERENCES `usuario` (`id_usuario`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_calificacion_viaje` FOREIGN KEY (`id_viaje`) REFERENCES `viaje` (`id_viaje`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_calificacion_puntuacion` CHECK ((`puntuacion` between 1 and 5)),
  CONSTRAINT `chk_calificacion_roles` CHECK (((`rol_emisor` in (_utf8mb4'RIDER',_utf8mb4'DRIVER')) and (`rol_receptor` in (_utf8mb4'RIDER',_utf8mb4'DRIVER')) and (`rol_emisor` <> `rol_receptor`)))
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `calificacion`
--

LOCK TABLES `calificacion` WRITE;
/*!40000 ALTER TABLE `calificacion` DISABLE KEYS */;
INSERT INTO `calificacion` VALUES (1,1,7,1,'RIDER','DRIVER',5,'Muy puntual y amable','2026-03-10 08:30:00'),(2,1,1,7,'DRIVER','RIDER',5,'Todo correcto durante el trayecto','2026-03-10 08:31:00'),(3,2,8,2,'RIDER','DRIVER',4,'Buen viaje, aunque hubo algo de trÃ¡fico','2026-03-10 10:00:00'),(4,2,2,8,'DRIVER','RIDER',5,'Cliente educado y puntual','2026-03-10 10:02:00'),(5,3,9,4,'RIDER','DRIVER',5,'ConducciÃ³n muy buena','2026-03-11 11:45:00'),(6,3,4,9,'DRIVER','RIDER',4,'Sin incidencias','2026-03-11 11:46:00'),(7,4,10,4,'RIDER','DRIVER',3,'LlegÃ³ bien pero el coche estaba algo sucio','2026-03-11 14:10:00'),(8,7,13,6,'RIDER','DRIVER',4,'Trayecto correcto','2026-03-13 09:30:00'),(9,7,6,13,'DRIVER','RIDER',5,'Muy amable','2026-03-13 09:31:00'),(10,8,14,2,'RIDER','DRIVER',5,'Excelente servicio','2026-03-13 15:00:00'),(11,8,2,14,'DRIVER','RIDER',5,'Todo perfecto','2026-03-13 15:01:00'),(12,10,7,4,'RIDER','DRIVER',4,'Buen viaje y buen trato','2026-03-14 22:00:00'),(13,10,4,7,'DRIVER','RIDER',4,'Buena experiencia','2026-03-14 22:02:00'),(14,11,16,1,'RIDER','DRIVER',5,'Muy profesional','2026-03-15 08:40:00'),(15,13,8,2,'RIDER','DRIVER',4,'Todo correcto','2026-03-16 10:50:00'),(16,13,2,8,'DRIVER','RIDER',4,'Sin problemas','2026-03-16 10:51:00'),(17,14,11,6,'RIDER','DRIVER',2,'Hubo retraso en la llegada','2026-03-16 19:20:00'),(18,14,6,11,'DRIVER','RIDER',4,'Cliente correcto','2026-03-16 19:22:00'),(19,15,12,3,'RIDER','DRIVER',5,'Ruta rÃ¡pida y cÃ³moda','2026-03-17 12:50:00'),(20,15,3,12,'DRIVER','RIDER',5,'Muy puntual','2026-03-17 12:51:00');
/*!40000 ALTER TABLE `calificacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company`
--

DROP TABLE IF EXISTS `company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `company` (
  `id_company` bigint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `cif` varchar(20) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(120) DEFAULT NULL,
  `activa` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_company`),
  UNIQUE KEY `cif` (`cif`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company`
--

LOCK TABLES `company` WRITE;
/*!40000 ALTER TABLE `company` DISABLE KEYS */;
INSERT INTO `company` VALUES (1,'MoveFast Mobility','A12345678','911111111','contacto@movefast.com',1),(2,'UrbanGo Transport','B87654321','922222222','info@urbango.com',1),(3,'CityRide Partners','C11223344','933333333','support@cityride.com',1),(4,'BlueCab Services','D55667788','944444444','hello@bluecab.com',1),(5,'MetroDrive Group','E99887766','955555555','contact@metrodrive.com',0);
/*!40000 ALTER TABLE `company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `driver`
--

DROP TABLE IF EXISTS `driver`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `driver` (
  `id_usuario` bigint NOT NULL,
  `id_company` bigint NOT NULL,
  `num_licencia` varchar(50) NOT NULL,
  `estado_driver` varchar(30) NOT NULL,
  `fecha_alta_driver` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `num_licencia` (`num_licencia`),
  KEY `fk_driver_company` (`id_company`),
  CONSTRAINT `fk_driver_company` FOREIGN KEY (`id_company`) REFERENCES `company` (`id_company`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_driver_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `driver`
--

LOCK TABLES `driver` WRITE;
/*!40000 ALTER TABLE `driver` DISABLE KEYS */;
INSERT INTO `driver` VALUES (1,1,'LIC-0001','ACTIVO','2026-01-10 09:30:00'),(2,2,'LIC-0002','ACTIVO','2026-01-11 10:30:00'),(3,1,'LIC-0003','ACTIVO','2026-01-12 11:30:00'),(4,3,'LIC-0004','ACTIVO','2026-01-13 12:30:00'),(5,4,'LIC-0005','INACTIVO','2026-01-14 13:30:00'),(6,2,'LIC-0006','ACTIVO','2026-01-15 14:30:00');
/*!40000 ALTER TABLE `driver` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `driver_vehiculo`
--

DROP TABLE IF EXISTS `driver_vehiculo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `driver_vehiculo` (
  `id_usuario_driver` bigint NOT NULL,
  `id_vehiculo` bigint NOT NULL,
  `fecha_desde` datetime NOT NULL,
  `fecha_hasta` datetime DEFAULT NULL,
  PRIMARY KEY (`id_usuario_driver`,`id_vehiculo`,`fecha_desde`),
  KEY `fk_drivervehiculo_vehiculo` (`id_vehiculo`),
  CONSTRAINT `fk_drivervehiculo_driver` FOREIGN KEY (`id_usuario_driver`) REFERENCES `driver` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_drivervehiculo_vehiculo` FOREIGN KEY (`id_vehiculo`) REFERENCES `vehiculo` (`id_vehiculo`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_fechas_driver_vehiculo` CHECK (((`fecha_hasta` is null) or (`fecha_hasta` >= `fecha_desde`)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `driver_vehiculo`
--

LOCK TABLES `driver_vehiculo` WRITE;
/*!40000 ALTER TABLE `driver_vehiculo` DISABLE KEYS */;
INSERT INTO `driver_vehiculo` VALUES (1,1,'2026-02-01 08:00:00',NULL),(2,2,'2026-02-01 08:30:00',NULL),(2,8,'2026-01-20 08:00:00','2026-01-31 20:00:00'),(3,3,'2026-02-02 09:00:00',NULL),(3,9,'2026-01-18 09:00:00','2026-02-15 18:00:00'),(4,4,'2026-02-02 09:30:00',NULL),(5,5,'2026-02-03 10:00:00','2026-03-01 00:00:00'),(5,6,'2026-03-01 00:01:00',NULL),(6,7,'2026-02-04 10:30:00',NULL);
/*!40000 ALTER TABLE `driver_vehiculo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `incidencia`
--

DROP TABLE IF EXISTS `incidencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `incidencia` (
  `id_incidencia` bigint NOT NULL AUTO_INCREMENT,
  `id_viaje` bigint NOT NULL,
  `id_usuario_reporta` bigint NOT NULL,
  `tipo_incidencia` varchar(50) NOT NULL,
  `descripcion` varchar(255) NOT NULL,
  `estado_incidencia` varchar(30) NOT NULL,
  `fecha_reporte` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_resolucion` datetime DEFAULT NULL,
  PRIMARY KEY (`id_incidencia`),
  KEY `idx_incidencia_viaje` (`id_viaje`),
  KEY `idx_incidencia_usuario` (`id_usuario_reporta`),
  KEY `idx_incidencia_estado` (`estado_incidencia`),
  CONSTRAINT `fk_incidencia_usuario` FOREIGN KEY (`id_usuario_reporta`) REFERENCES `usuario` (`id_usuario`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_incidencia_viaje` FOREIGN KEY (`id_viaje`) REFERENCES `viaje` (`id_viaje`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_incidencia_estado` CHECK ((`estado_incidencia` in (_utf8mb4'ABIERTA',_utf8mb4'EN_REVISION',_utf8mb4'RESUELTA',_utf8mb4'CERRADA'))),
  CONSTRAINT `chk_incidencia_fechas` CHECK (((`fecha_resolucion` is null) or (`fecha_resolucion` >= `fecha_reporte`)))
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `incidencia`
--

LOCK TABLES `incidencia` WRITE;
/*!40000 ALTER TABLE `incidencia` DISABLE KEYS */;
INSERT INTO `incidencia` VALUES (1,4,10,'LIMPIEZA','El vehÃ­culo presentaba suciedad en la parte trasera','RESUELTA','2026-03-11 14:05:00','2026-03-11 18:00:00'),(2,6,12,'CANCELACION_TARDIA','El viaje se cancelÃ³ despuÃ©s de la aceptaciÃ³n','CERRADA','2026-03-12 19:15:00','2026-03-12 20:00:00'),(3,8,14,'RETRASO','El conductor tardÃ³ mÃ¡s de lo esperado en llegar','RESUELTA','2026-03-13 14:50:00','2026-03-13 16:00:00'),(4,10,4,'CAMBIO_RUTA','El rider cambiÃ³ la ruta y se revisÃ³ el importe final','CERRADA','2026-03-14 21:25:00','2026-03-14 22:30:00'),(5,14,11,'RETRASO','El conductor quedÃ³ parado varios minutos antes de recoger','EN_REVISION','2026-03-16 19:10:00',NULL),(6,15,3,'OBJETO_OLVIDADO','El rider dejÃ³ una mochila en el vehÃ­culo','ABIERTA','2026-03-17 13:10:00',NULL),(7,16,13,'NO_DRIVER_FOUND','No hubo conductor disponible para aceptar el viaje','CERRADA','2026-03-17 23:05:00','2026-03-17 23:30:00');
/*!40000 ALTER TABLE `incidencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `metodo_pago`
--

DROP TABLE IF EXISTS `metodo_pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `metodo_pago` (
  `id_metodo_pago` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint NOT NULL,
  `tipo` varchar(30) NOT NULL,
  `detalle` varchar(100) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_metodo_pago`),
  KEY `idx_metodo_pago_usuario` (`id_usuario`),
  CONSTRAINT `fk_metodo_pago_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_metodo_pago_tipo` CHECK ((`tipo` in (_utf8mb4'TARJETA',_utf8mb4'PAYPAL',_utf8mb4'EFECTIVO',_utf8mb4'BIZUM')))
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `metodo_pago`
--

LOCK TABLES `metodo_pago` WRITE;
/*!40000 ALTER TABLE `metodo_pago` DISABLE KEYS */;
INSERT INTO `metodo_pago` VALUES (1,7,'TARJETA','Visa **** 1234',1),(2,7,'PAYPAL','lucia.paypal@email.com',1),(3,8,'TARJETA','Mastercard **** 9876',1),(4,9,'EFECTIVO','Pago en efectivo',1),(5,9,'BIZUM','600999999',1),(6,10,'TARJETA','Visa **** 4455',1),(7,11,'PAYPAL','claudia.paypal@email.com',1),(8,12,'TARJETA','Visa **** 7744',1),(9,13,'EFECTIVO','Pago en efectivo',1),(10,14,'TARJETA','Mastercard **** 1111',1),(11,15,'BIZUM','601666666',1),(12,16,'TARJETA','Visa **** 2020',1),(13,16,'PAYPAL','mario.paypal@email.com',0),(14,17,'TARJETA','Visa **** 3131',1),(15,18,'EFECTIVO','Pago en efectivo',0);
/*!40000 ALTER TABLE `metodo_pago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oferta`
--

DROP TABLE IF EXISTS `oferta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oferta` (
  `id_oferta` bigint NOT NULL AUTO_INCREMENT,
  `id_viaje` bigint NOT NULL,
  `id_driver` bigint NOT NULL,
  `id_viaje_aceptado` bigint DEFAULT NULL,
  `fecha_envio` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado_oferta` varchar(30) NOT NULL,
  `fecha_respuesta` datetime DEFAULT NULL,
  PRIMARY KEY (`id_oferta`),
  UNIQUE KEY `uq_oferta_aceptada_por_viaje` (`id_viaje_aceptado`),
  KEY `idx_oferta_viaje` (`id_viaje`),
  KEY `idx_oferta_driver` (`id_driver`),
  KEY `idx_oferta_estado` (`estado_oferta`),
  CONSTRAINT `fk_oferta_driver` FOREIGN KEY (`id_driver`) REFERENCES `driver` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_oferta_viaje` FOREIGN KEY (`id_viaje`) REFERENCES `viaje` (`id_viaje`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_oferta_fechas` CHECK (((`fecha_respuesta` is null) or (`fecha_respuesta` >= `fecha_envio`)))
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oferta`
--

LOCK TABLES `oferta` WRITE;
/*!40000 ALTER TABLE `oferta` DISABLE KEYS */;
INSERT INTO `oferta` VALUES (1,1,1,1,'2026-03-10 08:00:10','ACEPTADA','2026-03-10 08:01:00'),(2,1,2,NULL,'2026-03-10 08:00:10','RECHAZADA','2026-03-10 08:01:20'),(3,2,2,2,'2026-03-10 09:15:10','ACEPTADA','2026-03-10 09:16:00'),(4,2,3,NULL,'2026-03-10 09:15:10','RECHAZADA','2026-03-10 09:16:40'),(5,3,4,3,'2026-03-11 11:00:10','ACEPTADA','2026-03-11 11:01:00'),(6,3,1,NULL,'2026-03-11 11:00:10','RECHAZADA','2026-03-11 11:01:15'),(7,4,4,4,'2026-03-11 13:30:10','ACEPTADA','2026-03-11 13:31:00'),(8,5,1,NULL,'2026-03-12 18:00:10','PENDIENTE',NULL),(9,5,2,NULL,'2026-03-12 18:00:10','PENDIENTE',NULL),(10,5,6,NULL,'2026-03-12 18:00:10','PENDIENTE',NULL),(11,6,1,6,'2026-03-12 19:10:10','ACEPTADA','2026-03-12 19:11:00'),(12,7,6,7,'2026-03-13 08:45:10','ACEPTADA','2026-03-13 08:46:00'),(13,7,4,NULL,'2026-03-13 08:45:10','RECHAZADA','2026-03-13 08:46:20'),(14,8,2,8,'2026-03-13 14:00:10','ACEPTADA','2026-03-13 14:02:00'),(15,8,3,NULL,'2026-03-13 14:00:10','RECHAZADA','2026-03-13 14:02:40'),(16,9,3,9,'2026-03-19 17:30:10','ACEPTADA','2026-03-19 17:31:00'),(17,10,4,10,'2026-03-14 21:00:10','ACEPTADA','2026-03-14 21:01:00'),(18,10,2,NULL,'2026-03-14 21:00:10','RECHAZADA','2026-03-14 21:01:30'),(19,11,1,11,'2026-03-15 07:50:10','ACEPTADA','2026-03-15 07:51:00'),(20,12,2,NULL,'2026-03-15 15:10:10','PENDIENTE',NULL),(21,12,4,NULL,'2026-03-15 15:10:10','PENDIENTE',NULL),(22,13,2,13,'2026-03-16 10:00:10','ACEPTADA','2026-03-16 10:01:00'),(23,13,6,NULL,'2026-03-16 10:00:10','RECHAZADA','2026-03-16 10:01:50'),(24,14,6,14,'2026-03-16 18:20:10','ACEPTADA','2026-03-16 18:21:00'),(25,15,3,15,'2026-03-17 12:00:10','ACEPTADA','2026-03-17 12:02:00'),(26,15,1,NULL,'2026-03-17 12:00:10','RECHAZADA','2026-03-17 12:02:30'),(27,16,6,NULL,'2026-03-17 23:00:10','RECHAZADA','2026-03-17 23:01:00'),(28,16,4,NULL,'2026-03-17 23:00:10','RECHAZADA','2026-03-17 23:01:20');
/*!40000 ALTER TABLE `oferta` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_oferta_bi_set_id_viaje_aceptado` BEFORE INSERT ON `oferta` FOR EACH ROW BEGIN
    IF NEW.estado_oferta = 'ACEPTADA' THEN
        SET NEW.id_viaje_aceptado = NEW.id_viaje;
    ELSE
        SET NEW.id_viaje_aceptado = NULL;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_oferta_bu_set_id_viaje_aceptado` BEFORE UPDATE ON `oferta` FOR EACH ROW BEGIN
    IF NEW.estado_oferta = 'ACEPTADA' THEN
        SET NEW.id_viaje_aceptado = NEW.id_viaje;
    ELSE
        SET NEW.id_viaje_aceptado = NULL;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `rider`
--

DROP TABLE IF EXISTS `rider`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rider` (
  `id_usuario` bigint NOT NULL,
  PRIMARY KEY (`id_usuario`),
  CONSTRAINT `fk_rider_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rider`
--

LOCK TABLES `rider` WRITE;
/*!40000 ALTER TABLE `rider` DISABLE KEYS */;
INSERT INTO `rider` VALUES (7),(8),(9),(10),(11),(12),(13),(14),(15),(16),(17),(18);
/*!40000 ALTER TABLE `rider` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipo_ajuste_tarifa`
--

DROP TABLE IF EXISTS `tipo_ajuste_tarifa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipo_ajuste_tarifa` (
  `id_tipo_ajuste` bigint NOT NULL AUTO_INCREMENT,
  `codigo` varchar(50) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_tipo_ajuste`),
  UNIQUE KEY `codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipo_ajuste_tarifa`
--

LOCK TABLES `tipo_ajuste_tarifa` WRITE;
/*!40000 ALTER TABLE `tipo_ajuste_tarifa` DISABLE KEYS */;
INSERT INTO `tipo_ajuste_tarifa` VALUES (1,'TIEMPO_ESPERA','Tiempo de espera','Incremento por espera del conductor'),(2,'CAMBIO_DESTINO','Cambio de destino','El usuario modifica el destino durante el viaje'),(3,'PEAJE','Peaje','Coste adicional por peajes'),(4,'SUPLEMENTO_DEMANDA','Suplemento por demanda','Incremento por alta demanda'),(5,'DESCUENTO','Descuento','Ajuste negativo aplicado sobre la tarifa'),(6,'LIMPIEZA','Suplemento de limpieza','Coste adicional por incidencia de limpieza');
/*!40000 ALTER TABLE `tipo_ajuste_tarifa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `id_usuario` bigint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(80) NOT NULL,
  `apellidos` varchar(120) NOT NULL,
  `email` varchar(120) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `fecha_alta` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,'Carlos','Lopez Garcia','carlos.lopez@email.com','600111111','2026-01-10 09:00:00',1),(2,'Marta','Sanchez Ruiz','marta.sanchez@email.com','600222222','2026-01-11 10:00:00',1),(3,'David','Romero Gil','david.romero@email.com','600333333','2026-01-12 11:00:00',1),(4,'Elena','Navarro Perez','elena.navarro@email.com','600444444','2026-01-13 12:00:00',1),(5,'Jorge','Martin Leon','jorge.martin@email.com','600555555','2026-01-14 13:00:00',1),(6,'Paula','Diaz Moreno','paula.diaz@email.com','600666666','2026-01-15 14:00:00',1),(7,'Lucia','Fernandez Diaz','lucia.fernandez@email.com','600777777','2026-02-01 09:30:00',1),(8,'Javier','Martin Perez','javier.martin@email.com','600888888','2026-02-02 09:45:00',1),(9,'Ana','Gomez Torres','ana.gomez@email.com','600999999','2026-02-03 10:00:00',1),(10,'Sergio','Ruiz Castro','sergio.ruiz@email.com','601111111','2026-02-04 10:15:00',1),(11,'Claudia','Morales Vega','claudia.morales@email.com','601222222','2026-02-05 10:30:00',1),(12,'Pablo','Herrera Navas','pablo.herrera@email.com','601333333','2026-02-06 10:45:00',1),(13,'Laura','Iglesias Soto','laura.iglesias@email.com','601444444','2026-02-07 11:00:00',1),(14,'Raul','Prieto Mena','raul.prieto@email.com','601555555','2026-02-08 11:15:00',1),(15,'Nuria','Calvo Reyes','nuria.calvo@email.com','601666666','2026-02-09 11:30:00',1),(16,'Mario','Serrano Ruiz','mario.serrano@email.com','602111111','2026-02-10 12:00:00',1),(17,'Sara','Blanco Cano','sara.blanco@email.com','602222222','2026-02-11 12:10:00',1),(18,'Diego','Perez Vidal','diego.perez@email.com','602333333','2026-02-12 12:20:00',0);
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehiculo`
--

DROP TABLE IF EXISTS `vehiculo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehiculo` (
  `id_vehiculo` bigint NOT NULL AUTO_INCREMENT,
  `matricula` varchar(20) NOT NULL,
  `marca` varchar(50) NOT NULL,
  `modelo` varchar(50) NOT NULL,
  `color` varchar(30) DEFAULT NULL,
  `plazas` int NOT NULL,
  `anio` int DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_vehiculo`),
  UNIQUE KEY `matricula` (`matricula`),
  CONSTRAINT `chk_vehiculo_anio` CHECK (((`anio` is null) or (`anio` >= 1900))),
  CONSTRAINT `chk_vehiculo_plazas` CHECK ((`plazas` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehiculo`
--

LOCK TABLES `vehiculo` WRITE;
/*!40000 ALTER TABLE `vehiculo` DISABLE KEYS */;
INSERT INTO `vehiculo` VALUES (1,'1234ABC','Toyota','Corolla','Blanco',4,2022,1),(2,'5678DEF','Seat','Leon','Negro',4,2021,1),(3,'9012GHI','Tesla','Model 3','Rojo',4,2023,1),(4,'3456JKL','Hyundai','Ioniq','Azul',4,2022,1),(5,'7890MNO','Kia','Niro','Gris',4,2021,1),(6,'1122PQR','Renault','Megane','Blanco',4,2020,1),(7,'3344STU','Volkswagen','Golf','Negro',4,2022,1),(8,'5566VWX','Skoda','Octavia','Plata',4,2019,1),(9,'7788YZA','Peugeot','308','Azul',4,2020,0);
/*!40000 ALTER TABLE `vehiculo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `viaje`
--

DROP TABLE IF EXISTS `viaje`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `viaje` (
  `id_viaje` bigint NOT NULL AUTO_INCREMENT,
  `id_rider` bigint NOT NULL,
  `id_driver_asignado` bigint DEFAULT NULL,
  `id_metodo_pago` bigint NOT NULL,
  `estado` varchar(30) NOT NULL,
  `fecha_solicitud` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_aceptacion` datetime DEFAULT NULL,
  `fecha_inicio` datetime DEFAULT NULL,
  `fecha_fin` datetime DEFAULT NULL,
  `origen_lat` decimal(10,7) NOT NULL,
  `origen_lng` decimal(10,7) NOT NULL,
  `origen_direccion` varchar(255) NOT NULL,
  `destino_lat` decimal(10,7) NOT NULL,
  `destino_lng` decimal(10,7) NOT NULL,
  `destino_direccion` varchar(255) NOT NULL,
  `importe_estimado` decimal(10,2) NOT NULL,
  `importe_final` decimal(10,2) NOT NULL,
  `distancia_km` decimal(8,2) DEFAULT NULL,
  `duracion_min` decimal(8,2) DEFAULT NULL,
  PRIMARY KEY (`id_viaje`),
  KEY `idx_viaje_rider` (`id_rider`),
  KEY `idx_viaje_driver` (`id_driver_asignado`),
  KEY `idx_viaje_metodo_pago` (`id_metodo_pago`),
  KEY `idx_viaje_estado` (`estado`),
  CONSTRAINT `fk_viaje_driver` FOREIGN KEY (`id_driver_asignado`) REFERENCES `driver` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_viaje_metodo_pago` FOREIGN KEY (`id_metodo_pago`) REFERENCES `metodo_pago` (`id_metodo_pago`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_viaje_rider` FOREIGN KEY (`id_rider`) REFERENCES `rider` (`id_usuario`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_viaje_distancia` CHECK (((`distancia_km` is null) or (`distancia_km` >= 0))),
  CONSTRAINT `chk_viaje_duracion` CHECK (((`duracion_min` is null) or (`duracion_min` >= 0))),
  CONSTRAINT `chk_viaje_fechas` CHECK (((`fecha_aceptacion` is null) or (`fecha_aceptacion` >= `fecha_solicitud`))),
  CONSTRAINT `chk_viaje_importes` CHECK (((`importe_estimado` >= 0) and (`importe_final` >= 0)))
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `viaje`
--

LOCK TABLES `viaje` WRITE;
/*!40000 ALTER TABLE `viaje` DISABLE KEYS */;
INSERT INTO `viaje` VALUES (1,7,1,1,'FINALIZADO','2026-03-10 08:00:00','2026-03-10 08:01:00','2026-03-10 08:05:00','2026-03-10 08:25:00',40.4167750,-3.7037900,'Puerta del Sol, Madrid',40.4378698,-3.8196200,'Ciudad Universitaria, Madrid',12.50,15.00,8.40,20.00),(2,8,2,3,'FINALIZADO','2026-03-10 09:15:00','2026-03-10 09:16:00','2026-03-10 09:20:00','2026-03-10 09:48:00',40.4280000,-3.7040000,'Gran Via, Madrid',40.4893538,-3.6827461,'Plaza de Castilla, Madrid',14.00,14.00,9.10,28.00),(3,9,4,4,'FINALIZADO','2026-03-11 11:00:00','2026-03-11 11:01:00','2026-03-11 11:04:00','2026-03-11 11:35:00',40.4520000,-3.6880000,'Santiago Bernabeu, Madrid',40.4152600,-3.7074000,'Plaza Mayor, Madrid',13.00,13.00,7.80,31.00),(4,10,4,6,'FINALIZADO','2026-03-11 13:30:00','2026-03-11 13:31:00','2026-03-11 13:35:00','2026-03-11 13:55:00',40.4700000,-3.7000000,'Chamartin, Madrid',40.4090000,-3.6920000,'Retiro, Madrid',11.50,12.50,6.90,20.00),(5,11,NULL,7,'SOLICITADO','2026-03-12 18:00:00',NULL,NULL,NULL,40.3900000,-3.7200000,'Atocha, Madrid',40.4500000,-3.7000000,'Chamartin, Madrid',10.00,10.00,NULL,NULL),(6,12,1,8,'CANCELADO','2026-03-12 19:10:00','2026-03-12 19:11:00',NULL,NULL,40.4300000,-3.7100000,'Callao, Madrid',40.4200000,-3.6900000,'Museo del Prado, Madrid',8.50,8.50,NULL,NULL),(7,13,6,9,'FINALIZADO','2026-03-13 08:45:00','2026-03-13 08:46:00','2026-03-13 08:50:00','2026-03-13 09:18:00',40.4637000,-3.7492000,'Moncloa, Madrid',40.4169000,-3.7033000,'Sol, Madrid',12.00,13.25,8.10,28.00),(8,14,2,10,'FINALIZADO','2026-03-13 14:00:00','2026-03-13 14:02:00','2026-03-13 14:05:00','2026-03-13 14:44:00',40.4800000,-3.6600000,'IFEMA, Madrid',40.4100000,-3.7000000,'La Latina, Madrid',16.50,18.00,11.20,39.00),(9,15,3,11,'EN_CURSO','2026-03-19 17:30:00','2026-03-19 17:31:00','2026-03-19 17:36:00',NULL,40.4400000,-3.6900000,'Nuevos Ministerios, Madrid',40.4000000,-3.7200000,'Legazpi, Madrid',13.50,13.50,NULL,NULL),(10,7,4,2,'FINALIZADO','2026-03-14 21:00:00','2026-03-14 21:01:00','2026-03-14 21:05:00','2026-03-14 21:42:00',40.4180000,-3.7060000,'Opera, Madrid',40.4700000,-3.7200000,'Aravaca, Madrid',17.00,19.00,12.60,37.00),(11,16,1,12,'FINALIZADO','2026-03-15 07:50:00','2026-03-15 07:51:00','2026-03-15 07:55:00','2026-03-15 08:22:00',40.4020000,-3.6930000,'Embajadores, Madrid',40.4510000,-3.6890000,'Plaza Castilla, Madrid',15.00,15.00,9.40,27.00),(12,17,NULL,14,'SOLICITADO','2026-03-15 15:10:00',NULL,NULL,NULL,40.4320000,-3.7010000,'Bilbao, Madrid',40.4580000,-3.6760000,'Prosperidad, Madrid',9.00,9.00,NULL,NULL),(13,8,2,3,'FINALIZADO','2026-03-16 10:00:00','2026-03-16 10:01:00','2026-03-16 10:04:00','2026-03-16 10:32:00',40.4250000,-3.7020000,'Chueca, Madrid',40.4705000,-3.6885000,'Cuzco, Madrid',13.20,14.70,8.60,28.00),(14,11,6,7,'FINALIZADO','2026-03-16 18:20:00','2026-03-16 18:21:00','2026-03-16 18:25:00','2026-03-16 18:57:00',40.4060000,-3.6900000,'Atocha Renfe, Madrid',40.4590000,-3.7840000,'Aravaca, Madrid',16.80,19.30,10.80,32.00),(15,12,3,8,'FINALIZADO','2026-03-17 12:00:00','2026-03-17 12:02:00','2026-03-17 12:07:00','2026-03-17 12:39:00',40.4170000,-3.7030000,'Sol, Madrid',40.3770000,-3.6220000,'Vallecas, Madrid',18.00,18.00,11.60,32.00),(16,13,NULL,9,'CANCELADO','2026-03-17 23:00:00',NULL,NULL,NULL,40.4300000,-3.7050000,'Malasana, Madrid',40.4700000,-3.6900000,'Tetuan, Madrid',11.00,11.00,NULL,NULL);
/*!40000 ALTER TABLE `viaje` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'ride_hailing'
--

--
-- Dumping routines for database 'ride_hailing'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-25  1:17:14
