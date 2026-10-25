# Requerimientos del sistema

## 1. Introducción

El presente documento define los requerimientos de la aplicación móvil orientada a agentes de ventas de empresas de productos enlatados.

La aplicación tiene como propósito funcionar como una herramienta de apoyo independiente del sistema o material proporcionado por la empresa para la que trabaja cada agente. Su función principal es centralizar la información utilizada durante la gestión de los puntos de venta (PV), facilitar el registro y consulta de información, automatizar cálculos y apoyar el proceso de generación y negociación de pedidos.

La solución se plantea inicialmente para un número reducido de usuarios, pero su diseño deberá permitir su crecimiento progresivo y la incorporación de nuevos usuarios y funcionalidades.

Los requerimientos se clasifican en:

* Requerimientos funcionales.
* Requerimientos no funcionales.
* Reglas de negocio.
* Restricciones.
* Criterios de aceptación.
* Requerimientos pendientes de definición.

---

## 2. Actores

### 2.1. Agente de ventas

Es el usuario principal de la aplicación.

El agente de ventas podrá:

* Gestionar su sesión.
* Consultar y administrar sus puntos de venta.
* Registrar nuevos puntos de venta.
* Consultar y administrar información de productos.
* Consultar información relacionada con sus ventas.
* Registrar información del proceso de análisis del PV.
* Generar pedidos recomendados.
* Aplicar notas de crédito cuando corresponda.
* Consultar los beneficios asociados a una propuesta.
* Formalizar pedidos.
* Generar documentos PDF relacionados con los pedidos.

### 2.2. Administrador de la aplicación

No se contempla un rol administrativo independiente dentro del alcance inicial.

La aplicación deberá considerar que el agente de ventas será responsable de mantener actualizada la información que depende de él, debido a que la solución no tendrá conexión directa con la empresa proveedora.

---

# 3. Requerimientos funcionales

## 3.1. Gestión de autenticación y sesión

### RF-001 — Inicio de sesión

**Descripción:**

El sistema debe permitir al agente de ventas iniciar sesión utilizando sus credenciales registradas.

**Origen:** Necesidad de autenticación identificada durante el análisis de la solución.

**Prioridad:** Baja para la primera versión.

**Criterios de aceptación:**

* El usuario debe poder ingresar sus credenciales.
* El sistema debe validar las credenciales proporcionadas.
* El sistema debe permitir el acceso únicamente cuando las credenciales sean válidas.
* El sistema debe informar al usuario cuando las credenciales sean incorrectas.

---

### RF-002 — Inicio de sesión mediante Google

**Descripción:**

El sistema debe permitir al agente de ventas autenticarse mediante una cuenta de Google.

**Origen:** Necesidad identificada durante el análisis de la solución.

**Prioridad:** Baja para la primera versión.

**Criterios de aceptación:**

* El usuario debe poder seleccionar la opción de autenticación mediante Google.
* El sistema debe identificar al usuario autenticado.
* El sistema debe asociar la cuenta de Google con el usuario correspondiente de la aplicación.

---

### RF-003 — Persistencia de sesión

**Descripción:**

El sistema debe mantener la sesión del usuario en el dispositivo para evitar que este tenga que ingresar nuevamente sus credenciales cada vez que cierre y vuelva a abrir la aplicación.

**Origen:** Análisis y experiencia del desarrollador.

**Prioridad:** Baja para la primera versión.

**Criterios de aceptación:**

* El usuario autenticado debe poder cerrar y volver a abrir la aplicación sin tener que ingresar nuevamente sus credenciales mientras la sesión continúe siendo válida.
* El sistema debe permitir cerrar la sesión manualmente.
* Tiempo de duración de la sesión 15 días.
* Al finalizar la sesión se debe solicitar las credencialies para ingresar al sistema.

Pendiente
* Mecanismo utilizado para almacenar la información de sesión de forma segura.

---

### RF-004 — Recuperación de contraseña

**Descripción:**

El sistema debe permitir al usuario recuperar el acceso a su cuenta mediante el correo electrónico asociado.

**Origen:** Análisis del desarrollador.

**Prioridad:** Baja para la primera versión.

**Criterios de aceptación:**

* El usuario debe poder solicitar la recuperación de su contraseña.
* El sistema debe solicitar el correo electrónico asociado a la cuenta.
* El sistema debe validar la existencia de la cuenta asociada al correo.
* El sistema debe enviar el mecanismo correspondiente para recuperar el acceso.

**Pendiente de definición:**

* Flujo exacto de recuperación.
* Tiempo de validez del mecanismo de recuperación.
* Reglas para establecer una nueva contraseña.
* Comportamiento cuando el correo no esté registrado.

---

### RF-005 — Registro de usuario

**Descripción:**

El sistema debe permitir que un agente de ventas cree una cuenta proporcionando información básica.

**Datos identificados inicialmente:**

* Nombre.
* Apellido.
* Teléfono, opcional.
* Correo electrónico.
* Contraseña.

**Origen:** Análisis del desarrollador.

**Prioridad:** Baja para la primera versión.

**Criterios de aceptación:**

* El usuario debe poder completar el formulario de registro.
* El sistema debe validar los campos obligatorios.
* El sistema debe solicitar confirmación de contraseña.
* El sistema debe validar que las contraseñas coincidan.
* El sistema debe aplicar requisitos mínimos de seguridad a la contraseña:
  * Mínimo una mayúscula.
  * Mínimo tres minúsculas.
  * Mínimo cuatro números.
  * Mínimo un carácter especial.
* El correo electrónico debe ser único dentro del sistema.

**Pendiente de definición:**

* Verificación del correo electrónico.

---

## 3.2. Gestión de puntos de venta

### RF-006 — Consulta de puntos de venta

**Descripción:**

El sistema debe permitir al agente de ventas visualizar los puntos de venta asociados a su cuenta y consultar la información almacenada de cada uno.

**Origen:** Necesidad identificada durante el levantamiento de requerimientos.

**Prioridad:** Alta.

**Criterios de aceptación:**

* El sistema debe mostrar los PV asociados al agente autenticado.
* El usuario debe poder consultar la información almacenada de cada PV.
* El usuario no debe visualizar PV pertenecientes a otros agentes.

---

### RF-007 — Búsqueda de puntos de venta

**Descripción:**

El sistema debe permitir al agente localizar puntos de venta mediante criterios de búsqueda.

**Criterios iniciales:**

* Código del PV.
* Nombre del PV.

**Origen:** Necesidad identificada durante el levantamiento.

**Prioridad:** Alta.

**Pendiente de definición:**

* Determinar si la búsqueda será exacta o parcial.
* Determinar comportamiento cuando no existan resultados.

---

### RF-008 — Registro de punto de venta

**Descripción:**

El sistema debe permitir al agente registrar un nuevo punto de venta.

**Datos identificados inicialmente:**

* Nombre del PV.
* Código del PV, opcional.
* Ubicación, opcional.

**Origen:** Necesidad identificada durante el levantamiento.

**Prioridad:** Alta.

**Criterios de aceptación:**

* El usuario debe poder registrar un PV.
* El nombre debe ser obligatorio.
* El código debe poder registrarse cuando la empresa lo haya proporcionado.
* La ubicación debe ser opcional.
* El PV debe quedar asociado al agente que lo registra.

**Pendiente de definición:**

* Validar si existen otros datos del formulario utilizado actualmente por la empresa que sean útiles para el agente.
* Determinar si algún dato adicional puede resultar útil para futuros módulos de análisis.

---

### RF-009 — Actualización de punto de venta

**Descripción:**

El sistema debe permitir al agente actualizar la información de un PV previamente registrado.

**Datos iniciales:**

* Nombre.
* Código.
* Ubicación.

**Origen:** Necesidad identificada durante el levantamiento.

**Prioridad:** Media.

---

### RF-010 — Eliminación de punto de venta

**Descripción:**

El sistema debe permitir al agente eliminar un PV asociado a su cuenta.

**Origen:** Necesidad identificada durante el levantamiento.

**Prioridad:** Alta.

**Criterios de aceptación:**
* Eliminación lógica por medio del softdelete.
* Al aplicar eliminación lógica a un PV, los datos relacionados a la entidad en cuestión también se le debe aplicar softdelete.

**Pendiente de definición:**

* Determinar si un PV eliminado puede recuperarse.

---

## 3.3. Consulta del comportamiento de ventas

### RF-011 — Consulta del comportamiento de ventas por PV

**Descripción:**

El sistema debe permitir al agente consultar información relacionada con las ventas realizadas a sus puntos de venta.

La información identificada inicialmente incluye:

* Código del PV.
* Nombre del PV.
* Monto vendido durante la semana 1, corresponde a la suma total del pedido realizado por parte del cliente sin niguna deducción de algún tipo.
* Nota de crédito asociada a la venta de la semana 1.
* Monto vendido durante la semana 2, corresponde a la suma total del pedido realizado por parte del cliente sin niguna deducción de algún tipp.
* Nota de crédito asociada a la venta de la semana 2.
* Monto objetivo de ventas del PV.
* En la pantalla principal se podrá ver el comportamiento de las ventas en el mes vigente, sin embargo, el agente de ventas debe poder obeserva el historial del PV.
* Filtros por mes en el historial de un PV.

**Origen:** Necesidad identificada durante el levantamiento.

**Prioridad:** Alta.

**Pendiente de definición:**

* Definir cómo se calcula el monto objetivo de cada PV. [Ver Ideas de solución -> 1](../PreguntasFinales.md)
* Validar si únicamente se requieren semanas 1 y 2 o si la pantalla debe ser configurable. [Ver Preguntas -> 3](../PreguntasFinales.md)

---

### RF-012 — Búsqueda de información de ventas por PV

**Descripción:**

El sistema debe permitir localizar la información de ventas de un PV mediante criterios de búsqueda.

**Criterios iniciales:**

* Código del PV.
* Nombre del PV.

**Prioridad:** Alta.

---

# 4. Gestión de productos

## RF-013 — Consulta de productos

**Descripción:**

El sistema debe permitir al agente consultar los productos disponibles para la realización de pedidos y procesos de negociación.

La información específica que debe almacenarse todavía debe ser validada con el cliente.

**Origen:** Necesidad identificada durante el levantamiento.

**Prioridad:** Alta.

**Pendiente de definición:**

* Información que debe almacenarse por producto.
* Categorías de productos.
* Código del producto.
* Precio.
* Unidad de medida.
* Presentación.
* Estado del producto.
* Otros atributos necesarios para el proceso de ventas.

---

## RF-014 — Búsqueda y filtrado de productos

**Descripción:**

El sistema debe permitir al agente localizar productos mediante criterios de búsqueda y filtros.

**Prioridad:** Alta.

**Criterios de aceptación:**
* El sistema permite buscar productos por medio de nombre y/o código del producto.

**Pendiente de definición:**

* Filtros necesarios. [Ver Preguntas -> 4](../PreguntasFinales.md)
* Comportamiento de los filtros. [Ver Ideas de solución -> 3](../PreguntasFinales.md)
* Si la búsqueda será por nombre, código, categoría u otros atributos.

---

## RF-015 — Registro de producto

**Descripción:**

El sistema debe permitir al agente registrar nuevos productos.

**Origen:** Necesidad derivada de la independencia de la aplicación respecto de la empresa.

**Prioridad:** Baja.

**Pendiente de definición:**

* Datos obligatorios.
* Datos opcionales.
* Reglas de validación.

---

## RF-016 — Actualización de producto

**Descripción:**

El sistema debe permitir al agente actualizar la información de los productos almacenados.

La actualización es especialmente relevante para mantener actualizado el precio de los productos cuando este cambie.

**Prioridad:** Baja.

**Pendiente de definición:**

* Campos que pueden modificarse.
* Quién determina los nuevos valores.
* Reglas de validación.

---

## RF-017 — Eliminación de producto

**Descripción:**

El sistema debe permitir al agente eliminar productos que ya no deban estar disponibles para el proceso de ventas.

**Prioridad:** Baja.

**Criterios de aceptación**
* Eliminación por medio de softdelete.

**Pendiente de definición:**

* Determinar si los productos deben eliminarse físicamente o marcarse como inactivos.
* Determinar qué ocurre con los pedidos históricos que contienen el producto.
* Determinar si un producto descontinuado debe conservarse para efectos históricos.

---

# 5. Proceso de pedido

El proceso de pedido estará compuesto inicialmente por las siguientes etapas:

1. Análisis del Cardex.
2. Visualización de la propuesta de pedido.
3. Aplicación opcional de notas de crédito.
4. Visualización de beneficios.
5. Formalización del pedido.
6. Generación del documento PDF.

---

## RF-018 — Registro del análisis del Cardex

**Descripción:**

El sistema debe permitir al agente registrar la información utilizada actualmente durante el análisis del inventario del PV.

**Información identificada inicialmente:**

* Nombre del PV.
* Código del PV.
* Teléfono del PV.
* Forma de pago: crédito o contado.
* Pago por espacio fijo.
* Pago por espacio porcentual.
* Productos analizados.
* Cantidad en bodega (BOD).
* Cantidad en planta (PLAN).
* Cantidad en exhibición (EXIH).
* Recomendación de pedido.

**Origen:** Necesidad identificada durante el levantamiento.

**Prioridad:** Alta.

**Pendiente de definición:**

* Significado exacto de “pago por espacio fijo”.
* Significado exacto de “pago por espacio %”.
* Información adicional requerida por producto.
* Reglas para registrar BOD, PLAN y EXIH.
* Si las cantidades pueden ser cero.
* Si deben aceptarse valores decimales.
* Cómo se determina la recomendación de pedido.
* Si la recomendación será calculada automáticamente o ingresada/modificada manualmente por el agente.
* Cuándo se considera finalizado el Cardex.
* Si el Cardex pertenece a una visita, pedido o PV.

---

## RF-019 — Búsqueda de productos durante el Cardex

**Descripción:**

El sistema debe permitir al agente localizar productos durante el registro del Cardex mediante filtros.

**Criterios iniciales:**

* Código del producto.
* Nombre del producto.
* Categoría.

**Prioridad:** Alta.

**Pendiente de definición:**

* Validar los filtros con el cliente.
* Determinar comportamiento de búsqueda.
* Determinar si los productos mostrados deben limitarse a los productos disponibles para el agente.

---

## RF-020 — Visualización del pedido recomendado

**Descripción:**

El sistema debe generar una vista de los productos que poseen una cantidad recomendada de pedido a partir de la información registrada durante el análisis del Cardex.

La vista debe mostrar inicialmente:

* Nombre del producto.
* Código del producto.
* Cantidad general disponible, correspondiente a la suma de BOD + PLAN + EXIH.
* Cantidad recomendada para pedir.

**Prioridad:** Alta.

**

**Pendiente de definición:**

* Quién puede modificar la cantidad recomendada (el agente de venta).
* Qué ocurre cuando la cantidad recomendada es cero (no se agrega a la factura final).
* Si el agente puede agregar productos que inicialmente no hayan sido recomendados.

---

## RF-021 — Aplicación de nota de crédito

**Descripción:**

El sistema debe permitir al agente aplicar una nota de crédito de manera opcional a los productos incluidos en una propuesta de pedido.

**Información identificada para el cálculo:**

* Costo actual del producto.
* Costo con descuento ofrecido.
* Diferencia.
* Costo final por unidad.
* Costo total del pedido del producto.

**Prioridad:** Alta.

**Pendiente de definición:**

* Si existen diferentes tipos de NC.
* Tratamiento de valores monetarios y decimales.

---

## RF-022 — Cálculo de beneficios de la propuesta

**Descripción:**

El sistema debe calcular y mostrar los beneficios asociados a la propuesta de pedido para apoyar el proceso de negociación.

La información identificada inicialmente incluye:

* Monto total con NC.
* Monto total sin NC.
* Diferencia o ahorro generado por la NC.
* Utilidad asociada a la propuesta.

La fórmula preliminar identificada para la utilidad es: [Ver Preguntas -> 6](../PreguntasFinales.md)

> Utilidad = costo total con NC × porcentaje aplicado 

**Prioridad:** Alta.

---

## RF-023 — Confirmar del pedido

**Descripción:**

El sistema debe permitir al agente confirmar la información del pedido una vez finalizada la negociación.

**Prioridad:** Alta.


---

## RF-024 — Generación de PDF del pedido

**Descripción:**

El sistema debe permitir generar un documento PDF con la información necesaria del pedido formalizado.

**Prioridad:** Alta.

**Pendiente de definición:**

* Determinar exactamente qué información debe contener el PDF. [Ver Preguntas -> 7](../PreguntasFinales.md)
* Determinar si incluye NC.
* Determinar si incluye beneficios.
* Determinar si incluye información del PV.
* Determinar si incluye información del agente.

---

# 6. Requerimientos no funcionales

Los siguientes requerimientos se identifican preliminarmente a partir del alcance y de las características esperadas de la solución. Deben ser refinados y cuantificados cuando sea necesario.

## RNF-001 — Compatibilidad móvil

La aplicación debe ser compatible con dispositivos móviles que utilicen Android e iOS.

## RNF-002 — Persistencia de información

La información registrada por el usuario debe almacenarse de manera persistente para permitir su posterior consulta.

## RNF-003 — Seguridad de autenticación

La aplicación debe proteger las credenciales y los mecanismos utilizados para mantener las sesiones de los usuarios.

## RNF-004 — Usabilidad

La interfaz debe estar optimizada para facilitar el uso de la aplicación durante las actividades realizadas por el agente de ventas.

## RNF-005 — Disponibilidad de información

La información necesaria para realizar las actividades del agente debe poder consultarse de manera organizada y oportuna.

**Pendiente de definición:**

Los requerimientos no funcionales deberán complementarse posteriormente con métricas verificables cuando sea necesario, por ejemplo:

* Tiempo máximo de respuesta.
* Disponibilidad esperada.
* Requisitos de seguridad.
* Compatibilidad mínima de versiones de Android/iOS.
* Comportamiento ante pérdida de conexión.
* Capacidad esperada de usuarios.
* Capacidad de almacenamiento.

---

# 7. Reglas de negocio

## RN-001 — Asociación de puntos de venta

Cada punto de venta debe estar asociado al agente de ventas correspondiente.

## RN-002 — Independencia respecto de la empresa

La aplicación no tendrá inicialmente una conexión directa con los sistemas internos de la empresa proveedora.

Por esta razón, el agente deberá mantener actualizada la información necesaria para utilizar la aplicación.

## RN-003 — Código del punto de venta

El código del PV es un dato proporcionado por la empresa al agente y puede no estar disponible al momento de registrar inicialmente el punto de venta.

## RN-004 — Nota de crédito

La nota de crédito representa un descuento aplicado a los productos de acuerdo con las condiciones comerciales correspondientes.

## RN-005 — Aplicación opcional de NC

La aplicación de una nota de crédito no es obligatoria para todos los productos o pedidos.

## RN-006 — Recomendación de pedido

La recomendación de pedido se genera a partir del análisis de la información registrada durante el Cardex y puede ser modificada para adaptarse a las necesidades y preferencias del PV.

## RN-007 — Información de productos

La información de los productos debe poder ser actualizada por el agente debido a que la aplicación no tendrá conexión directa con la empresa.

## RN-008 — Precio del producto

El precio de un producto puede cambiar y la aplicación debe permitir actualizarlo.

**Pendiente de validación:** determinar si debe conservarse un historial de precios y cómo debe afectar los pedidos históricos.

---

# 8. Restricciones

## RE-001 — Independencia de sistemas empresariales

La aplicación no tendrá acceso directo a los sistemas internos de la empresa proveedora durante la primera versión.

## RE-002 — Usuario inicial

La primera versión será utilizada inicialmente por un único agente de ventas.

Sin embargo, la estructura de la solución deberá permitir la incorporación de nuevos usuarios posteriormente.

## RE-003 — Realización del pedido

La aplicación no realizará directamente el pedido ante la empresa.

La formalización dentro de la aplicación tendrá como propósito registrar y respaldar la información del pedido, pero la ejecución del pedido ante la empresa se encuentra fuera del alcance.

## RE-004 — Roles

No se contempla un sistema de permisos basado en múltiples roles dentro de la primera versión.

---

# 9. Criterios de aceptación

Los criterios de aceptación específicos deberán definirse para cada requerimiento antes de considerar su implementación como finalizada.

Como criterio general:

* El requerimiento debe cumplir la funcionalidad descrita.
* Los datos obligatorios deben validarse.
* Los cálculos deben producir resultados consistentes con las reglas de negocio aprobadas.
* El comportamiento debe poder verificarse mediante pruebas.
* El resultado debe coincidir con las reglas y procesos aprobados durante la validación con el cliente.

---

# 10. Requerimientos fuera del alcance

Los siguientes elementos se encuentran fuera del alcance inicial:

1. Sistema de permisos por roles.
2. Realización directa del pedido ante la empresa desde la aplicación.
3. Análisis avanzado de la información recolectada.

---

# 11. Trazabilidad

La trazabilidad deberá permitir relacionar las necesidades identificadas durante el levantamiento con los requerimientos que las implementan y posteriormente con las pruebas correspondientes.

La relación esperada será:

**Necesidad → Requerimiento → Criterio de aceptación → Prueba**

Esta sección se completará conforme se validen y aprueben los requerimientos.

---

