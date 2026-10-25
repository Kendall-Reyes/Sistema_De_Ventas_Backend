## Preguntas
1. RF-008 — Registro de punto de venta
2. ¿Con qué frecuencia de vuelve abrir un PV después de cerrarlo? RF-010 — Eliminación de punto de venta
3. ¿Existe la posibilidad de que haya más de 2 ventas al mes en un mismo PV? **Solución: ver Ideas de Solución -> 2**
4. ¿Cuales filtro de búsqueda serían necesarios para encontrar un producto?
5. ¿Qué significa los datos solicitados en el cardex Pago por espacio fijo y Pago por espacio porcentual? ¿Qué información se considera necesaria de almacenar al realizar el procesos del Cardex?
6. ¿Qué tipos de porcentajes hay?
7. ¿Qué información debe tener el pdf final?


## Ideas de solución
1. ### RF-011 — Consulta del comportamiento de ventas por PV -> **Pendiente de definición:** -> Definir cómo se calcula el monto objetivo de cada PV.
   * Solicitar en alguna parte del dashboard, configuración del perfil o visualización del comportamientos de las ventas el monto objetivo de venta del mes actual.
   * Agregar a los PV un atributo que lo clasifique despendiendo de cuánto compre el PV: pequeño si la compra es baja, mediano si la compra es moderada y grande si la compra es sustanciosa. (validar los nombres de clasificación)
   * Distribuir el porcentaje que corresponde a cada punto de venta dependiendo de su clasificación.

2. ### RF-011 — Consulta del comportamiento de ventas por PV -> **Pendiente de definición:** -> Validar si únicamente se requieren semanas 1 y 2 o si la pantalla debe ser configurable.
En caso de que la **pregunta 3** sea positiva, analizar la mejor forma para mostrar de forma limpa la informa. Idea: botón para agregar una venta y no limitarse a semana 1 y semana 2 como se tiene en la plantilla.

3. ## RF-014 — Búsqueda y filtrado de productos -> **Pendiente de definición:** -> Comportamiento de los filtros. 
<a id="validacion-password"></a> Se visualiza un input para poder escribir la descripción con lo que se pretende realizar la búsqueda y un drop down con las opciones/atributos con lo que el sistema hará la búsqueda. Al seleccionar una de las opciones del drop down se tiene que actualizar la lista mostrando automáticamente los productos pretenecientes a esa categoría y, hasta colocar alguna palabra en el input se haré un segundo filtrado.

Quedé ## RF-020 — Visualización del pedido recomendado