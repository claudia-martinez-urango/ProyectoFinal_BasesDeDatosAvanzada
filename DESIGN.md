# DESIGN.md

## 1. Objetivo del diseño

El objetivo de esta base de datos es modelar el funcionamiento de una plataforma de ride-hailing similar a Uber o Cabify. El sistema debe permitir que un rider solicite un viaje entre dos puntos, que la solicitud se envíe a varios conductores y que el primer conductor que acepte quede asignado al trayecto. Además, el modelo debe contemplar empresas, vehículos, métodos de pago, ajustes de tarifa, incidencias, valoraciones, auditoría, consultas analíticas, seguridad, copias de seguridad y monitorización técnica.

El diseño no se limita únicamente a almacenar información básica sobre viajes, sino que busca representar el ciclo completo de la operativa. Por ello se han incluido elementos que permiten reconstruir qué ocurre en cada viaje, desde la solicitud inicial hasta la finalización, incluyendo ofertas, pagos, posibles incidencias, calificaciones y eventos de auditoría.

## 2. Criterios generales de diseño

Se ha optado por un modelo relacional porque el problema presenta entidades claramente diferenciadas, relaciones bien definidas y necesidad de integridad en operaciones críticas. En este caso no solo es importante almacenar información, sino también garantizar consistencia en aspectos como la asignación del conductor, la trazabilidad de los cambios o la correcta asociación entre usuarios, viajes y pagos.

Durante el diseño se han seguido tres ideas principales. La primera ha sido evitar duplicidades y campos ambiguos, separando en tablas distintas aquellos conceptos que merecen entidad propia. La segunda ha sido facilitar la explotación analítica posterior, de forma que el modelo no solo sirva para operar, sino también para medir actividad, ingresos, aceptación e incidencias. La tercera ha sido acercar el esquema a un caso real, incorporando elementos como calificaciones, métodos de pago, incidencias, procedimientos almacenados, backups y monitorización técnica.

También se ha tenido en cuenta que algunas operaciones requieren especial cuidado desde el punto de vista de la concurrencia. El caso más claro es la aceptación de una oferta por parte de un conductor, ya que varios conductores pueden recibir una oferta para el mismo viaje, pero solo uno debe quedar asignado finalmente.

## 3. Descripción de las entidades

### 3.1. Company

La entidad `company` representa a la empresa a la que pertenece cada conductor. Una empresa puede tener varios conductores, mientras que cada conductor pertenece a una única empresa. Esta decisión permite medir ingresos, aceptación y rendimiento no solo por conductor, sino también por compañía, algo útil para la parte analítica del sistema.

### 3.2. Usuario

La tabla `usuario` almacena la información común a cualquier persona registrada en la plataforma: nombre, apellidos, email, teléfono, fecha de alta y estado. Se ha decidido centralizar estos datos en una sola entidad para evitar duplicarlos en tablas separadas.

A partir de esta tabla se derivan dos especializaciones: `driver` y `rider`. De esta forma, un mismo diseño permite distinguir entre atributos comunes y atributos específicos de cada rol.

### 3.3. Driver

La entidad `driver` contiene la parte específica del conductor: empresa a la que pertenece, número de licencia, estado y fecha de alta como conductor. Su relación principal es con `company`, pero también participa en viajes, ofertas, vehículos y valoraciones.

Separar `driver` de `usuario` tiene sentido porque no todos los usuarios del sistema son conductores y porque el conductor necesita atributos propios que no tienen por qué aparecer en el resto de usuarios.

### 3.4. Rider

La entidad `rider` representa al usuario que solicita viajes. Se ha dejado deliberadamente simple porque su función principal es conectarse con la tabla `viaje`. Esto permite que cada viaje tenga un rider claramente identificado sin duplicar información personal.

### 3.5. Vehículo

La tabla `vehiculo` almacena los datos de los coches: matrícula, marca, modelo, color, número de plazas, año y estado. Se ha considerado una entidad independiente porque el vehículo tiene identidad propia y puede formar parte del histórico operativo del sistema.

### 3.6. Driver_Vehiculo

La relación entre conductores y vehículos no se ha modelado directamente, sino mediante la tabla intermedia `driver_vehiculo`. La razón es que la relación no es simplemente 1:1. Un conductor puede cambiar de coche y un vehículo puede haber sido utilizado por distintos conductores en momentos diferentes. Por eso esta tabla incluye fechas de inicio y fin, permitiendo mantener histórico.

### 3.7. Metodo_Pago

La tabla `metodo_pago` se ha añadido para modelar de forma más realista cómo se paga cada viaje. Un usuario puede tener varios métodos de pago asociados, por ejemplo tarjeta, PayPal, Bizum o efectivo. Después, cada viaje referencia el método de pago concreto con el que se abona.

Se ha preferido crear esta tabla en lugar de guardar el método de pago como texto dentro de `viaje`, ya que así se evita repetir información, se permite reutilización y se deja el sistema preparado para ampliaciones futuras.

### 3.8. Viaje

La tabla `viaje` es la entidad central del modelo. Cada viaje almacena quién lo solicita, qué conductor queda asignado finalmente, qué método de pago se utiliza, el estado del trayecto, las distintas marcas temporales y la información de origen, destino, duración, distancia e importes.

Esta tabla es la más importante desde el punto de vista de negocio, ya que conecta con riders, drivers, ofertas, ajustes, incidencias, calificaciones y pagos. A partir de ella se puede reconstruir prácticamente todo el ciclo operativo del servicio.

Los estados del viaje permiten representar su evolución: inicialmente puede estar solicitado, después aceptado, en curso, finalizado o cancelado. Esto facilita tanto el control operativo como la explotación posterior de métricas.

### 3.9. Oferta

La entidad `oferta` permite representar que un mismo viaje se envíe a varios conductores. Este punto es especialmente importante porque el sistema no plantea una asignación directa, sino una difusión de la solicitud a múltiples conductores, quedándose el viaje el primero que acepta.

Gracias a esta tabla se puede registrar el envío, el estado de cada oferta y la fecha de respuesta. Además, facilita tanto el control de concurrencia como el cálculo de métricas de aceptación.

Como mejora adicional, se ha incorporado un mecanismo para reforzar a nivel de base de datos que un mismo viaje no pueda tener más de una oferta aceptada. Para ello se utiliza una columna auxiliar `id_viaje_aceptado`, un índice único y triggers que actualizan dicha columna en función del estado de la oferta.

### 3.10. Tipo_Ajuste_Tarifa

Se ha creado la tabla `tipo_ajuste_tarifa` para normalizar los motivos de los ajustes. En lugar de guardar texto libre en cada ajuste, se define un catálogo de tipos posibles, como tiempo de espera, peaje, cambio de destino o descuento.

La principal ventaja de esta decisión es que evita inconsistencias semánticas. Sin esta tabla podrían aparecer variantes diferentes para un mismo motivo, lo que complicaría consultas, agrupaciones y análisis.

### 3.11. Ajuste_Tarifa

La tabla `ajuste_tarifa` recoge los cambios concretos aplicados a un viaje. Cada ajuste se vincula tanto al viaje como al tipo de ajuste correspondiente. Además, incluye una descripción libre para detallar el caso particular y el importe asociado.

Esta separación entre tipo y ajuste permite mantener un modelo limpio: el catálogo define la categoría y la tabla operativa registra la ocurrencia real.

### 3.12. Calificacion

La entidad `calificacion` permite que los usuarios se valoren entre sí tras un viaje. En este caso se ha diseñado para soportar tanto valoraciones del rider al driver como del driver al rider. Por ello se almacenan emisor, receptor, rol de cada uno, puntuación, comentario y fecha.

Se ha decidido crear una sola tabla en lugar de dos, porque estructuralmente la información es la misma. Esto reduce redundancia y permite explotar fácilmente medias, rankings y análisis de calidad del servicio.

### 3.13. Incidencia

La tabla `incidencia` registra problemas o situaciones anómalas relacionadas con un viaje, por ejemplo retrasos, cambios de ruta, objetos olvidados o incidencias de limpieza. Cada incidencia queda asociada al viaje y al usuario que la reporta.

Esta entidad mejora el realismo del modelo y resulta muy útil de cara al análisis posterior, ya que permite conocer cuántos problemas se producen, de qué tipo son y si han sido resueltos o no.

### 3.14. Auditoria_Evento

La tabla `auditoria_evento` se ha incluido para registrar operaciones relevantes del sistema. En lugar de ligarla a una sola entidad, se ha diseñado como auditoría genérica, con campos como tabla afectada, id del registro, acción, detalle, usuario y fecha.

La ventaja de este enfoque es que permite auditar viajes, ofertas, ajustes, incidencias o cualquier otra tabla sin necesidad de crear una auditoría específica para cada una.

## 4. Relaciones principales del modelo

Las relaciones más relevantes son las siguientes:

- Una `company` tiene varios `driver`.
- Un `usuario` puede especializarse en `driver` o en `rider`.
- Un `usuario` puede tener varios `metodo_pago`.
- Un `driver` y un `vehiculo` se relacionan mediante `driver_vehiculo`.
- Un `rider` puede solicitar muchos `viaje`.
- Un `driver` puede quedar asignado a muchos `viaje`.
- Un `viaje` puede generar muchas `oferta`.
- Un `driver` puede recibir muchas `oferta`.
- Un `viaje` puede tener varios `ajuste_tarifa`.
- Un `tipo_ajuste_tarifa` clasifica muchos `ajuste_tarifa`.
- Un `viaje` puede tener varias `calificacion`.
- Un `viaje` puede tener varias `incidencia`.
- Un `usuario` puede emitir y recibir varias `calificacion`.
- Un `usuario` puede reportar varias `incidencia`.
- Un `metodo_pago` puede utilizarse en varios `viaje`.

Estas relaciones permiten representar correctamente tanto la operativa principal como los procesos auxiliares de control, calidad y análisis.

## 5. Decisiones de modelado más importantes

### Separación entre usuario, driver y rider

Se ha optado por una generalización mediante `usuario` y dos especializaciones. La razón es que hay atributos comunes a todos los usuarios y atributos que solo tienen sentido para conductores o pasajeros. Esta decisión evita duplicidades y mejora la organización del modelo.

### Uso de tabla intermedia para conductor y vehículo

La existencia de `driver_vehiculo` se justifica porque la relación entre ambos no es estática. En un escenario real, un conductor puede cambiar de coche y un vehículo puede haber sido utilizado por varias personas en distintos momentos. Guardar esta información en una tabla intermedia con fechas permite mantener histórico.

### Normalización de los ajustes de tarifa

Se ha separado `tipo_ajuste_tarifa` de `ajuste_tarifa` para evitar problemas derivados de los textos libres y mejorar el análisis posterior. Esta decisión es un ejemplo claro de normalización útil: no complica demasiado el diseño y sí mejora notablemente la calidad de los datos.

### Método de pago como entidad propia

Se ha considerado más correcto modelar el método de pago como una entidad independiente en lugar de un simple atributo de `viaje`. Esto da más flexibilidad, permite que un usuario tenga varios métodos y hace el sistema más escalable.

### Inclusión de incidencias y calificaciones

Ambas entidades se han añadido para mejorar el realismo del modelo. Las incidencias permiten reflejar problemas del servicio y las calificaciones aportan una medida de calidad. En una plataforma real ambos elementos son muy relevantes y además enriquecen el dashboard y las consultas analíticas.

### Auditoría genérica

La auditoría se ha planteado de forma genérica porque así puede reutilizarse para diferentes tablas del sistema. Esta decisión simplifica el diseño y evita crear múltiples tablas de auditoría con estructuras parecidas.

### Restricción de una única oferta aceptada

Uno de los puntos críticos del modelo es evitar que dos conductores acepten el mismo viaje. Para reforzar esta regla se ha añadido una columna auxiliar en `oferta`, llamada `id_viaje_aceptado`, junto con un índice único.

La lógica consiste en que esta columna solo toma el valor del viaje cuando la oferta está aceptada. Si la oferta está pendiente o rechazada, el valor queda a `NULL`. Como MySQL permite varios valores `NULL` en un índice único, se pueden tener muchas ofertas pendientes o rechazadas para un mismo viaje, pero solo una aceptada.

Esta decisión complementa el uso de transacciones y bloqueos, aportando una garantía adicional a nivel de estructura de base de datos.

## 6. Integridad y consistencia

Para mantener la integridad del sistema se han definido claves primarias y foráneas en todas las relaciones importantes. También se han utilizado restricciones `CHECK` para validar rangos y estados, por ejemplo en puntuaciones, métodos de pago, plazas del vehículo, estados de viaje, estados de oferta o estados de incidencia.

Además, la consistencia del sistema no depende solo del modelo, sino también de la forma de operar sobre él. Por eso se han contemplado transacciones y locks en consultas críticas, especialmente en el caso de aceptación de ofertas, donde es necesario garantizar que dos conductores no puedan quedarse el mismo viaje a la vez.

La integridad se refuerza también mediante triggers asociados a la tabla `oferta`, que actualizan automáticamente la columna auxiliar utilizada para controlar que solo exista una oferta aceptada por viaje.

## 7. Procedimientos almacenados

Se ha añadido el archivo `procedures.sql` para encapsular operaciones habituales del sistema mediante procedimientos almacenados. La finalidad no es sustituir los datos de prueba de `data.sql`, sino definir operaciones reutilizables que puedan ejecutarse cuando sea necesario.

La diferencia principal es que `data.sql` carga datos fijos de prueba, mientras que `procedures.sql` define acciones. Por ejemplo, `data.sql` puede insertar varios viajes iniciales, mientras que un procedimiento como `sp_crear_viaje` permite crear nuevos viajes de forma controlada siempre que se llame con `CALL`.

Los procedimientos incluidos son:

- `sp_crear_viaje`
- `sp_enviar_oferta`
- `sp_aceptar_oferta`
- `sp_finalizar_viaje`
- `sp_registrar_incidencia`

El procedimiento más relevante es `sp_aceptar_oferta`, ya que encapsula la operación crítica de aceptar un viaje. Este procedimiento comprueba que la oferta existe, que está pendiente, que el viaje sigue solicitado, que no tiene conductor asignado, acepta la oferta seleccionada, rechaza las demás ofertas del mismo viaje, asigna el conductor y registra auditoría.

Además, utiliza transacciones y bloqueos `FOR UPDATE`, por lo que la operación se ejecuta de forma consistente. Si algo falla, se revierte mediante `ROLLBACK`.

Esta mejora permite centralizar reglas de negocio dentro de la base de datos, reduce errores y hace que operaciones complejas puedan ejecutarse de forma más sencilla.

## 8. Índices y rendimiento

Se han creado índices sobre claves foráneas y campos de consulta frecuente, como el estado de los viajes, el conductor asignado, el rider, el tipo de ajuste o el estado de las incidencias. La finalidad es mejorar el rendimiento de búsquedas, joins y consultas de dashboard.

Además de los índices orientados a rendimiento, destaca el índice único `uq_oferta_aceptada_por_viaje`, que tiene una doble función. Por un lado, permite controlar mejor las ofertas aceptadas. Por otro, actúa como garantía de integridad para impedir que un mismo viaje tenga dos ofertas aceptadas.

Esta parte es importante porque el sistema no solo debe estar correctamente modelado, sino que también debe poder responder de forma eficiente a consultas operativas y analíticas.

## 9. Seguridad y explotación

El diseño de la base de datos se completa con una capa de permisos y con consultas analíticas. Por un lado, se han definido distintos perfiles de usuario para administración, operativa, backup, consulta y análisis. Por otro, el modelo está pensado para poder responder preguntas de negocio como ingresos por conductor, tasas de aceptación, uso de métodos de pago, incidencias por tipo o media de valoraciones.

Los usuarios principales son `admin_app`, `operador_app`, `analista_app`, `backup_app` y `consulta_app`. Cada uno tiene permisos diferentes, aplicando el principio de mínimo privilegio. Además, se ha añadido el usuario `exporter`, utilizado por MySQL Exporter para obtener métricas técnicas de la base de datos sin necesidad de usar una cuenta administradora.

También se han concedido permisos `EXECUTE` al usuario `operador_app` sobre los procedimientos almacenados operativos. Esto permite que el operador pueda ejecutar acciones controladas como crear viajes, enviar ofertas o registrar incidencias, sin necesidad de tener privilegios totales sobre la base de datos.

## 10. Dashboard analítico

El archivo `dashboard.sql` permite explotar los datos desde un punto de vista analítico. Este archivo contiene consultas más elaboradas que las consultas operativas, ya que no está pensado para simular el uso diario del sistema, sino para obtener métricas agregadas.

Entre las métricas incluidas se encuentran la tasa de aceptación por conductor y empresa, los ingresos generados, los viajes por estado, los viajes por hora, los métodos de pago más utilizados, las valoraciones medias y las incidencias por tipo y estado.

También se incluyen algunas consultas de monitorización de base de datos, como tamaño de tablas, número de conexiones o configuración de consultas lentas. De esta forma, el dashboard cubre tanto una parte de negocio como una parte técnica básica.

## 11. Backups y recuperación

Se ha definido una estrategia de copias de seguridad mediante `mysqldump`. Además, se ha añadido un montaje en Docker para que la carpeta local `backups` del proyecto esté conectada con la carpeta `/backups` dentro del contenedor de MySQL.

Esta decisión evita que los backups queden atrapados dentro del contenedor. Cuando se genera un backup con `mysqldump`, el fichero se guarda directamente en la carpeta local del proyecto, lo que facilita conservarlo, moverlo o restaurarlo.

La estrategia no se ha limitado a generar el fichero de backup. También se ha probado una restauración real en una base independiente llamada `ride_hailing_restore`. Después de restaurar, se comprobaron datos importantes como usuarios, viajes y ofertas, y también se verificó que el índice avanzado `uq_oferta_aceptada_por_viaje` se restauraba correctamente.

Esto demuestra que el backup no es solo teórico, sino que permite recuperar la base de datos.

## 12. Volúmenes Docker

El proyecto utiliza volúmenes y montajes para separar los datos importantes del ciclo de vida de los contenedores.

El volumen `mysql_data` guarda los datos reales de MySQL, como tablas, usuarios, índices, permisos, triggers y datos insertados. Gracias a este volumen, si el contenedor se recrea sin borrar volúmenes, la base de datos se conserva.

El montaje `./backups:/backups` sirve para guardar copias de seguridad fuera del contenedor. No es redundante con `mysql_data`, porque `mysql_data` guarda la base activa, mientras que `backups` guarda copias exportadas en formato SQL.

También se utilizan volúmenes para Prometheus y Grafana. `prometheus_data` guarda el histórico de métricas recogidas, mientras que `grafana_data` conserva dashboards y configuración de Grafana.

## 13. Monitorización con Prometheus y Grafana

Además del dashboard SQL, se ha añadido una capa de monitorización técnica mediante Prometheus y Grafana. Esta parte no sustituye al dashboard de negocio, sino que lo complementa.

La arquitectura utilizada es:

```text
MySQL → MySQL Exporter → Prometheus → Grafana
```

MySQL Exporter se conecta a MySQL mediante el usuario `exporter` y expone métricas internas de la base de datos. Prometheus recoge esas métricas periódicamente y Grafana permite visualizarlas mediante gráficos.

Esta monitorización permite responder preguntas técnicas como si MySQL está activo, cuántas conexiones hay abiertas, cuántas consultas se han ejecutado, si existen consultas lentas o cuánto tiempo lleva funcionando el servidor.

La métrica más básica es `mysql_up`. Si su valor es `1`, significa que MySQL está activo y que Prometheus puede recoger correctamente sus métricas.

La diferencia respecto a `dashboard.sql` es clara: `dashboard.sql` mide el negocio, mientras que Prometheus y Grafana miden la salud técnica del sistema.

## 14. Pruebas realizadas

Se han realizado pruebas sobre las partes principales del proyecto. En primer lugar, se comprobó la creación correcta de tablas y la carga de datos iniciales. Después se ejecutaron las consultas operativas y las consultas del dashboard para validar que los datos podían explotarse correctamente.

También se probaron los procedimientos almacenados. Se creó un viaje mediante `sp_crear_viaje`, se enviaron ofertas mediante `sp_enviar_oferta`, se aceptó una de ellas mediante `sp_aceptar_oferta`, se comprobó que las demás quedaban rechazadas, se finalizó el viaje mediante `sp_finalizar_viaje` y se registró una incidencia mediante `sp_registrar_incidencia`.

La restricción de una única oferta aceptada se validó intentando insertar una segunda oferta aceptada para un viaje que ya tenía una. MySQL devolvió un error de clave duplicada, confirmando que la restricción funciona.

La estrategia de backup también fue probada mediante restauración en una base independiente. Por último, se comprobó la monitorización con Prometheus y Grafana verificando que la métrica `mysql_up` devolvía `1`.

## 15. Mejoras introducidas respecto al mínimo

Aunque el diseño básico ya cubría la gestión de viajes y ofertas, se han añadido varias mejoras para hacer el proyecto más completo y realista:

- inclusión de `metodo_pago`
- inclusión de `calificacion`
- inclusión de `incidencia`
- normalización del ajuste de tarifa
- auditoría genérica
- restricción avanzada para una única oferta aceptada
- triggers sobre ofertas
- procedimientos almacenados
- permisos `EXECUTE` para el operador
- volumen local para backups
- validación real de restauración
- monitorización con Prometheus y Grafana
- usuario específico para métricas técnicas
- volúmenes para persistencia de datos, métricas y dashboards

Estas decisiones permiten presentar una práctica más sólida, más realista y mejor justificada.

## 16. Conclusión

El modelo final cubre la operativa principal de una plataforma de ride-hailing y, al mismo tiempo, incorpora elementos que mejoran su calidad técnica y su utilidad analítica. Se ha buscado un equilibrio entre cumplir lo exigido por la práctica y construir una base de datos razonable desde el punto de vista profesional.

La tabla `viaje` actúa como núcleo del sistema, conectando riders, conductores, ofertas, pagos, ajustes, incidencias y calificaciones. A su alrededor se han incorporado mecanismos de integridad, auditoría, seguridad, procedimientos almacenados, backups y monitorización.

El resultado es un esquema coherente, escalable y adecuado tanto para operaciones del día a día como para consultas de negocio, seguridad, recuperación y control técnico del sistema.