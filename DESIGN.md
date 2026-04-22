# DESIGN.md

## 1. Objetivo del diseño

El objetivo de esta base de datos es modelar el funcionamiento de una plataforma de ride-hailing similar a Uber o Cabify. El sistema debe permitir que un rider solicite un viaje entre dos puntos, que la solicitud se envíe a varios conductores y que el primer conductor que acepte quede asignado al trayecto. Además, el modelo debe contemplar empresas, vehículos, métodos de pago, ajustes de tarifa, incidencias, valoraciones, auditoría, consultas analíticas y seguridad. Todo ello responde al alcance funcional y técnico planteado en la práctica. :contentReference[oaicite:0]{index=0}

## 2. Criterios generales de diseño

Se ha optado por un modelo relacional porque el problema presenta entidades claramente diferenciadas, relaciones bien definidas y necesidad de integridad en operaciones críticas. En este caso no solo es importante almacenar información, sino también garantizar consistencia en aspectos como la asignación del conductor, la trazabilidad de los cambios o la correcta asociación entre usuarios, viajes y pagos.

Durante el diseño se han seguido tres ideas principales. La primera ha sido evitar duplicidades y campos ambiguos, separando en tablas distintas aquellos conceptos que merecen entidad propia. La segunda ha sido facilitar la explotación analítica posterior, de forma que el modelo no solo sirva para operar, sino también para medir actividad, ingresos, aceptación e incidencias. La tercera ha sido acercar el esquema a un caso real, incorporando elementos como calificaciones, métodos de pago e incidencias, que no son estrictamente mínimos pero enriquecen mucho el sistema.

## 3. Descripción de las entidades

### 3.1. Company

La entidad `company` representa a la empresa a la que pertenece cada conductor. Una empresa puede tener varios conductores, mientras que cada conductor pertenece a una única empresa. Esta decisión permite medir ingresos, aceptación y rendimiento no solo por conductor, sino también por compañía, algo que se pide en la parte de métricas. :contentReference[oaicite:1]{index=1}

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

### 3.9. Oferta

La entidad `oferta` permite representar que un mismo viaje se envíe a varios conductores. Este punto es especialmente importante porque el enunciado no plantea una asignación directa, sino una difusión de la solicitud a múltiples conductores, quedándose el viaje el primero que acepta. :contentReference[oaicite:2]{index=2}

Gracias a esta tabla se puede registrar el envío, el estado de cada oferta y la fecha de respuesta. Además, facilita tanto el control de concurrencia como el cálculo de métricas de aceptación.

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

La tabla `incidencia` registra problemas o situaciones anómalas relacionadas con un viaje, por ejemplo retrasos, cancelaciones tardías, objetos olvidados o incidencias de limpieza. Cada incidencia queda asociada al viaje y al usuario que la reporta.

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

## 6. Integridad y consistencia

Para mantener la integridad del sistema se han definido claves primarias y foráneas en todas las relaciones importantes. También se han utilizado restricciones `CHECK` para validar rangos y estados, por ejemplo en puntuaciones, métodos de pago, plazas del vehículo o estados de incidencia.

Además, la consistencia del sistema no depende solo del modelo, sino también de la forma de operar sobre él. Por eso se han contemplado transacciones y locks en consultas críticas, especialmente en el caso de aceptación de ofertas, donde es necesario garantizar que dos conductores no puedan quedarse el mismo viaje a la vez. Este requisito aparece de forma expresa en el enunciado. :contentReference[oaicite:3]{index=3}

## 7. Índices y rendimiento

Se han creado índices sobre claves foráneas y campos de consulta frecuente, como el estado de los viajes, el conductor asignado, el rider, el tipo de ajuste o el estado de las incidencias. La finalidad es mejorar el rendimiento de búsquedas, joins y consultas de dashboard.

Esta parte es importante porque la práctica no solo pide modelar, sino también desarrollar índices para optimizar consultas. :contentReference[oaicite:4]{index=4}

## 8. Seguridad y explotación

El diseño de la base de datos se completa con una capa de permisos y con consultas analíticas. Por un lado, se han definido distintos perfiles de usuario para administración, operativa, backup y consulta. Por otro, el modelo está pensado para poder responder preguntas de negocio como ingresos por conductor, tasas de aceptación, uso de métodos de pago, incidencias por tipo o media de valoraciones.

De esta forma, el sistema no se limita a almacenar datos, sino que también sirve como base para la monitorización y la toma de decisiones.

## 9. Mejoras introducidas respecto al mínimo

Aunque el enunciado ya define una base clara, se han añadido varias mejoras para hacer el trabajo más completo:

- inclusión de `metodo_pago`
- inclusión de `calificacion`
- inclusión de `incidencia`
- normalización del ajuste de tarifa
- auditoría genérica
- diseño preparado para análisis y dashboard

Estas decisiones permiten presentar una práctica más sólida, más realista y mejor justificada.

## 10. Conclusión

El modelo final cubre la operativa principal de una plataforma de ride-hailing y, al mismo tiempo, incorpora elementos que mejoran su calidad técnica y su utilidad analítica. Se ha buscado un equilibrio entre cumplir lo exigido por la práctica y construir una base de datos razonable desde el punto de vista profesional. El resultado es un esquema coherente, escalable y adecuado tanto para operaciones del día a día como para consultas de negocio, seguridad y auditoría.