# 3. Diseño técnico

> **Estado del documento:** propuesta inicial para el MVP. Las
> decisiones marcadas como pendientes deberán confirmarse cuando se
> terminen de definir las reglas de negocio y los criterios de
> aceptación.

## 3.1 Principios y criterios técnicos

Las decisiones técnicas se guiarán por los siguientes principios,
priorizados según el alcance actual: una aplicación móvil funcional, con
buena experiencia de uso, inicialmente para entre uno y cinco usuarios y
sin integración directa con los sistemas de la empresa proveedora.

### Simplicidad proporcional al alcance

-   Preferir soluciones conocidas y mantenibles que resuelvan las
    necesidades reales del MVP.
-   Evitar microservicios, infraestructura distribuida y abstracciones
    que no aporten valor al tamaño inicial del sistema.
-   Incorporar nuevas capacidades cuando exista una necesidad validada,
    no solo como demostración de conocimiento.

### Mantenibilidad y legibilidad

-   Usar TypeScript tanto en el cliente como en el servidor.
-   Mantener módulos con responsabilidades claras y dependencias
    explícitas.
-   Aplicar convenciones consistentes de nombres, formato, pruebas y
    documentación.
-   Mantener las reglas comerciales suficientemente aisladas para
    probarlas sin depender de la interfaz ni de la base de datos.

### Seguridad

-   La autenticación y autorización de las operaciones del sistema se
    validarán en el backend.
-   Las contraseñas no se almacenarán en texto plano; se utilizará un
    mecanismo de hash apropiado si la autenticación se implementa en el
    backend.
-   Los tokens de sesión se almacenarán mediante almacenamiento seguro
    del dispositivo, no en almacenamiento genérico sin protección.
-   Las consultas y operaciones deberán limitarse a los datos que
    pertenecen al usuario autenticado.
-   Las credenciales de infraestructura y las claves privadas no se
    incluirán en el repositorio.

### Integridad de los datos y de los cálculos

-   Las reglas comerciales deben validarse antes de formalizar un
    pedido.
-   Los cálculos de cantidades, descuentos, totales y beneficios deberán
    tener pruebas automatizadas y basarse en reglas aprobadas.
-   El backend será la autoridad para validar y persistir los datos
    definitivos.
-   Los valores monetarios se manejarán con una representación decimal
    adecuada, evitando depender de aritmética binaria de punto flotante
    para cálculos financieros.
-   Los cambios de esquema se gestionarán mediante migraciones
    versionadas.

### Experiencia de usuario

-   Priorizar flujos cortos, formularios claros, mensajes de validación
    comprensibles y prevención de errores.
-   Diseñar primero para el uso móvil, considerando que el agente puede
    utilizar la aplicación durante visitas a puntos de venta.
-   Mostrar estados claros de carga, guardado, error y confirmación.
-   No ocultar al usuario los errores que requieran una acción de su
    parte.

### Escalabilidad razonable

-   Aunque la primera versión tenga pocos usuarios, cada punto de venta
    y cada registro de negocio deberá asociarse al usuario
    correspondiente.
-   La solución deberá permitir agregar usuarios sin rediseñar toda la
    aplicación.
-   La arquitectura no se optimizará anticipadamente para cargas que aún
    no existen; se revisará con datos de uso reales.

### Alcance de conectividad

-   El MVP requerirá conexión a internet para comunicarse con el
    backend.
-   La operación sin conexión **no forma parte del alcance comprometido
    del MVP**.
-   Si posteriormente se incorpora, se evaluará como una capacidad
    específica para Android e iOS. No se asumirá que la versión web
    tendrá el mismo comportamiento offline.
-   La aplicación deberá informar los errores de conexión y permitir
    reintentar las operaciones cuando corresponda.

## 3.2 Arquitectura

### Enfoque arquitectónico

Se utilizará una arquitectura cliente-servidor con una API REST y un
backend organizado como **monolito modular**.

Esta opción permite separar la interfaz móvil/web, las reglas de negocio
y la persistencia sin introducir el costo operativo de múltiples
servicios. El cliente no se conectará directamente a PostgreSQL: toda
operación de negocio pasará por el backend.

### Componentes principales

1.  **Cliente multiplataforma:** aplicación desarrollada con React
    Native y Expo, con soporte para Android, iOS y web desde una base de
    código compartida cuando las capacidades de cada plataforma lo
    permitan.
2.  **API backend:** aplicación NestJS que expone endpoints REST,
    autentica solicitudes, valida datos y ejecuta las reglas de negocio.
3.  **Base de datos relacional:** PostgreSQL, utilizada por el backend
    para persistir usuarios, puntos de venta, productos y registros de
    las operaciones del sistema.
4.  **Proveedor de autenticación de Google:** se integrará para el
    inicio de sesión con Google, una vez definido el flujo y la
    configuración de credenciales. El backend deberá validar la
    identidad recibida antes de asociarla con una cuenta de la
    aplicación.
5.  **Servicio de despliegue:** inicialmente se elegirá una plataforma
    de bajo costo que permita desplegar la API y utilizar una base de
    datos administrada. La infraestructura concreta queda pendiente de
    selección y validación.

### Capas y módulos

#### Cliente

La estructura del cliente separará, como mínimo:

-   **Presentación:** pantallas, componentes visuales, navegación y
    estados de interfaz.
-   **Aplicación:** coordinación de casos de uso y flujo de las
    operaciones del usuario.
-   **Acceso a datos y servicios:** comunicación HTTP con la API, manejo
    de sesión y transformación de respuestas.
-   **Validación de formularios:** validaciones de entrada orientadas a
    la experiencia de usuario. Estas no reemplazan las validaciones del
    backend.

La lógica de negocio que sea relevante para la integridad del sistema no
deberá existir exclusivamente en la interfaz.

#### Backend

El backend se organizará por módulos funcionales, evitando dividirlo en
servicios independientes durante el MVP:

-   **Autenticación y usuarios:** identidad, sesión y asociación de
    datos con el usuario.
-   **Puntos de venta (PV):** registro, consulta, actualización y baja
    lógica cuando corresponda.
-   **Productos:** información de productos y actualización de datos
    administrados por el agente.
-   **Cardex:** registro de la información recopilada durante la visita
    al punto de venta.
-   **Propuestas de pedido:** recomendación, modificación de cantidades,
    aplicación opcional de notas de crédito, cálculo de beneficios y
    confirmación.
-   **Generación de documentos:** preparación de la información
    requerida para generar el PDF del pedido. La generación del archivo
    se resolverá en el cliente si la biblioteca elegida y las
    necesidades del formato lo permiten.

Los límites definitivos de los módulos se ajustarán a medida que se
cierren las reglas de negocio. No se crearán módulos independientes solo
para aplicar una estructura teórica.

Dentro de cada módulo de NestJS se utilizarán las responsabilidades
propias del framework ---controladores, servicios y acceso a datos---
sin añadir capas de abstracción adicionales hasta que sean necesarias.

### Comunicación entre componentes

-   El cliente enviará solicitudes HTTP a la API REST mediante HTTPS en
    los entornos desplegados.
-   Los controladores del backend recibirán las solicitudes y delegarán
    el procesamiento en los servicios correspondientes.
-   Las entradas se validarán en el límite de la API antes de ejecutar
    operaciones de negocio.
-   Los servicios del backend consultarán o modificarán PostgreSQL
    mediante Prisma ORM.
-   El backend devolverá respuestas consistentes, con códigos HTTP
    adecuados y mensajes de error que no expongan información sensible.
-   La autenticación se realizará mediante una sesión/token validado por
    el backend. El detalle de emisión, renovación y expiración de tokens
    se documentará al implementar el flujo.
-   La formalización de un pedido registrará y respaldará la información
    dentro de esta aplicación; no enviará el pedido directamente a la
    empresa proveedora.

### Diagramas necesarios

Se elaborarán los siguientes diagramas, manteniéndolos alineados con la
implementación:

1.  **Diagrama de contexto:** usuarios, aplicación y sistemas externos
    relevantes, incluido el proveedor de autenticación.
2.  **Diagrama de contenedores/componentes:** cliente, API, base de
    datos y servicios externos.
3.  **Diagrama entidad-relación:** entidades, relaciones, claves y
    restricciones principales.
4.  **Diagramas de secuencia para flujos críticos:** autenticación,
    registro/consulta de un PV y creación-confirmación de una propuesta
    de pedido.
5.  **Diagrama de despliegue:** infraestructura del MVP y comunicación
    entre sus componentes.

No es necesario crear un diagrama por cada pantalla o endpoint. Los
diagramas se priorizarán según su utilidad para tomar decisiones,
explicar flujos críticos y mantener el sistema.

## 3.3 Stack tecnológico

El stack propuesto se elige por la compatibilidad con el alcance móvil
multiplataforma, la posibilidad de compartir TypeScript entre cliente y
servidor, la mantenibilidad y el valor formativo para el portafolio.

| Área                        | Tecnología propuesta                                                   | Uso                                                                                                                                 |
| --------------------------- | ---------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| Lenguaje                    | TypeScript                                                             | Cliente y backend, con tipos compartidos conceptualmente; no se acoplarán ambos proyectos mediante importaciones internas frágiles. |
| Framework móvil             | React Native + Expo                                                    | Aplicación para Android e iOS.                                                                                                      |
| Soporte web                 | React Native Web mediante Expo                                         | Reutilización de pantallas y lógica cuando sea viable; las diferencias de plataforma se resolverán explícitamente.                  |
| Navegación                  | React Navigation                                                       | Navegación entre pantallas y flujos de la aplicación.                                                                               |
| Formularios                 | React Hook Form                                                        | Estado y gestión de formularios.                                                                                                    |
| Validación de esquemas      | Zod                                                                    | Validación reutilizable de datos de entrada y tipos derivados cuando corresponda.                                                   |
| Comunicación con API        | Fetch o cliente HTTP ligero                                            | Solicitudes a la API REST; se evitará agregar una biblioteca si las necesidades no lo justifican.                                   |
| Estado remoto               | TanStack Query                                                         | Consultas, caché, estados de carga/error e invalidación de datos obtenidos de la API.                                               |
| Estado local compartido     | Estado propio de React; Zustand solo si aparece una necesidad concreta | Evitar un gestor global de estado por defecto.                                                                                      |
| Backend                     | NestJS                                                                 | API REST y organización modular del servidor.                                                                                       |
| Persistencia                | PostgreSQL                                                             | Base de datos relacional central.                                                                                                   |
| ORM y migraciones           | Prisma ORM                                                             | Consultas tipadas, modelo de datos y migraciones versionadas.                                                                       |
| Autenticación               | Autenticación de la aplicación y proveedor OAuth de Google             | Inicio de sesión con correo/contraseña y Google; flujo definitivo pendiente de implementación.                                      |
| Almacenamiento seguro móvil | Expo SecureStore                                                       | Almacenamiento de tokens u otros datos pequeños sensibles compatibles con esta solución.                                            |
| PDF                         | Expo Print, sujeto a una prueba técnica                                | Generación del PDF en las plataformas objetivo. Se verificará el comportamiento requerido en web, Android e iOS.                    |
| Pruebas backend             | Jest y Supertest                                                       | Pruebas unitarias e integración/e2e de la API.                                                                                      |
| Pruebas cliente             | Jest y React Native Testing Library                                    | Pruebas de componentes y comportamiento de interfaz.                                                                                |
| Control de versiones        | Git y GitHub                                                           | Historial, revisión de cambios y repositorio.                                                                                       |
| Integración continua        | GitHub Actions                                                         | Ejecución automatizada de validaciones y pruebas.                                                                                   |
| Entorno local               | Node.js, pnpm y Docker Compose                                         | Instalación reproducible de dependencias y ejecución local de PostgreSQL; el backend también podrá contenerizarse si aporta valor.  |
| Calidad de código           | ESLint y Prettier                                                      | Detección de problemas comunes y formato consistente.                                                                               |
| Documentación técnica       | Markdown, PlantUML y Swagger                                           | Requisitos, decisiones, diagramas e instrucciones de desarrollo.                                                                    |


### Infraestructura y despliegue

-   El desarrollo local utilizará Docker Compose para levantar
    PostgreSQL sin exigir una instalación local independiente del motor.
-   El despliegue inicial priorizará costo bajo, configuración sencilla
    y facilidad de mantenimiento. La plataforma de hosting y el
    proveedor de PostgreSQL se elegirán después de verificar límites,
    disponibilidad, copias de seguridad y condiciones del plan.
-   Las variables de entorno se utilizarán para configurar URLs,
    credenciales y secretos según el entorno.
-   Las migraciones de Prisma se ejecutarán de forma controlada en los
    despliegues.
-   Se documentará el procedimiento de despliegue y recuperación básica.
-   La migración posterior a AWS se considera una etapa de aprendizaje y
    evolución del proyecto, no un requisito para poner en funcionamiento
    el MVP. La solución evitará dependencias innecesarias con un
    proveedor, pero no se diseñará una abstracción de infraestructura
    sin una necesidad concreta.

### Decisiones técnicas pendientes de validar

Antes de cerrar la selección definitiva, deberán comprobarse mediante
prototipos o decisiones registradas:

-   Compatibilidad real de las pantallas y bibliotecas seleccionadas en
    Android, iOS y web.
-   Flujo de autenticación con Google y persistencia segura de sesión.
-   Generación y descarga/compartición del PDF en cada plataforma.
-   Reglas exactas para Cardex, recomendación, notas de crédito, valores
    monetarios e historial de precios.
-   Campos y formato definitivo del PDF.
-   Plataforma de despliegue y límites de los planes gratuitos o de bajo
    costo.

## 3.4 Patrones de diseño

No se incorporarán patrones de diseño por obligación. La implementación
utilizará las estructuras que ofrecen los frameworks y solo introducirá
abstracciones adicionales cuando resuelvan un problema concreto.

### Enfoques que sí se aplicarán

-   **Separación por módulos funcionales:** el backend organizará las
    capacidades del sistema en módulos como usuarios, puntos de venta,
    productos, Cardex y propuestas de pedido. Es una decisión de
    organización arquitectónica, no una justificación para introducir
    capas innecesarias.
-   **Inyección de dependencias de NestJS:** se utilizará el mecanismo
    nativo del framework para proporcionar servicios y dependencias a
    los componentes que los necesiten.
-   **DTOs y validación de entradas:** los contratos de la API se
    representarán mediante objetos de transferencia de datos y se
    validarán en el límite del backend.
-   **Funciones de dominio comprobables:** los cálculos comerciales que
    puedan expresarse como transformaciones deterministas se mantendrán
    separados de la interfaz y de los detalles de infraestructura, para
    poder probarlos directamente.

### Patrones que no se introducirán de forma preventiva

No se crearán factories, repositorios genéricos, estrategias
intercambiables, singletons manuales, buses de eventos ni otras
abstracciones únicamente para demostrar conocimiento. Si aparece un
requisito real que justifique una de estas soluciones, se documentará el
problema, las alternativas consideradas y la decisión tomada.

## 3.5 Estándares y convenciones de desarrollo

### Naming conventions

-   **Variables y funciones:** `camelCase`.
-   **Clases, tipos e interfaces:** `PascalCase`.
-   **Constantes:** `UPPER_SNAKE_CASE` solo para constantes
    verdaderamente globales o valores fijos; para el resto se usará
    `camelCase`.
-   **Archivos y carpetas:** nombres consistentes en `kebab-case` cuando
    el tooling lo permita.
-   **Componentes React:** `PascalCase`.
-   **Tablas y campos de base de datos:** se mantendrá una convención
    consistente en el esquema de Prisma y PostgreSQL; se evitará mezclar
    estilos sin necesidad.
-   Los nombres deberán describir el propósito del elemento y evitar
    abreviaturas ambiguas, salvo términos del dominio ya acordados como
    PV, Cardex y NC.

Las reglas concretas de nombres se codificarán en la configuración del
proyecto cuando sea posible.

### Estructura del proyecto

Se mantendrán cliente y backend claramente separados, inicialmente en un
único repositorio si esto facilita el desarrollo y la integración:

``` text
agente-ventas/
├── apps/
│   ├── mobile/              # Cliente Expo (Android, iOS y web)
│   └── api/                 # API NestJS
├── docs/                    # Requisitos, decisiones y diagramas
├── docker-compose.yml       # Servicios locales, como PostgreSQL
├── .github/workflows/       # Automatizaciones CI
└── README.md
```

Esta estructura es una propuesta inicial. Se podrá ajustar a las
convenciones de Expo, NestJS y pnpm sin forzar una estructura monorepo
compleja. Cada aplicación tendrá sus propias responsabilidades y
configuración.

Dentro del backend, la estructura se organizará por módulos funcionales.
Dentro del cliente, se separarán pantallas, componentes compartidos,
navegación y acceso a la API. No se crearán carpetas vacías para capas
que aún no se utilizan.

### Estilo de código

-   TypeScript con comprobación estricta habilitada siempre que las
    dependencias lo permitan.
-   ESLint para reglas estáticas y Prettier para formato.
-   Evitar `any` salvo que exista una razón documentada y acotada.
-   Preferir funciones pequeñas y nombres claros; no fragmentar código
    en múltiples abstracciones sin beneficio.
-   No duplicar reglas comerciales entre pantallas. Cuando una regla
    deba verificarse también en el cliente, la validación definitiva
    seguirá estando en el backend.
-   No dejar secretos, credenciales, datos reales de usuarios ni
    archivos locales sensibles en el repositorio.
-   Configurar `.env.example` con nombres de variables y valores
    ficticios, sin secretos.

### Git, ramas y commits

Para un proyecto individual con alcance pequeño se utilizará un flujo
simple:

-   `main`: rama estable, con cambios que hayan pasado las validaciones
    acordadas.
-   Ramas breves `feature/<descripcion>` para funcionalidades y
    `fix/<descripcion>` para correcciones cuando el cambio lo
    justifique.
-   Evitar ramas de larga duración y no crear ramas para cambios
    triviales si solo añaden burocracia.
-   Commits pequeños, coherentes y descriptivos.
-   Convención recomendada de commits: **Conventional Commits**, por
    ejemplo `feat: add point-of-sale form`,
    `fix: validate credit note amount` y
    `test: cover order calculations`.
-   No incluir en un mismo commit cambios funcionales no relacionados
    cuando puedan separarse razonablemente.
-   Los cambios que afecten reglas de negocio, esquema de datos o
    decisiones técnicas deberán quedar explicados en el commit, la
    documentación o ambos.

### Manejo de errores

-   La API devolverá códigos HTTP apropiados y un formato consistente de
    errores.
-   Los errores de validación se distinguirán de errores de
    autenticación/autorización, recursos inexistentes y fallos internos.
-   Los mensajes mostrados al usuario serán comprensibles y no expondrán
    trazas, secretos ni detalles internos.
-   Los errores inesperados se registrarán en el servidor con
    información útil para depuración, evitando registrar contraseñas,
    tokens u otros datos sensibles.
-   El cliente mostrará estados de error y opciones de recuperación
    cuando correspondan; no asumirá que una solicitud fallida se
    completó.
-   Los errores de conexión deberán diferenciarse de los errores de
    validación o de reglas de negocio.

### Validaciones

-   Validar datos de entrada en el cliente para mejorar la experiencia y
    en el backend para garantizar integridad.
-   Validar en el servidor la identidad del usuario y la pertenencia de
    cada recurso antes de consultarlo o modificarlo.
-   Aplicar restricciones en la base de datos cuando correspondan,
    incluyendo claves primarias, foráneas, unicidad y campos
    obligatorios.
-   Definir límites, redondeo y precisión monetaria cuando se validen
    las reglas comerciales.
-   No asumir que las fórmulas preliminares de utilidad, descuentos o
    recomendación son definitivas hasta validarlas con el usuario del
    negocio.

### Testing

-   Las pruebas unitarias cubrirán principalmente reglas de negocio y
    cálculos.
-   Las pruebas de integración comprobarán servicios y persistencia con
    una base de datos de prueba.
-   Las pruebas e2e validarán los flujos críticos de la API.
-   Las pruebas del cliente verificarán formularios, estados de error y
    comportamientos de los flujos principales.
-   Las pruebas deberán ser repetibles y no depender de datos personales
    reales.
-   Las pruebas automatizadas se ejecutarán localmente y en GitHub
    Actions.

### Documentación del código

-   Documentar el propósito, las restricciones y las decisiones no
    obvias, no describir línea por línea lo que el código ya expresa
    claramente.
-   Documentar reglas de negocio cuya interpretación no sea evidente.
-   Mantener el README actualizado con prerrequisitos, configuración,
    ejecución local, pruebas y despliegue.
-   Registrar decisiones técnicas relevantes en ADRs breves cuando
    impliquen una alternativa significativa o un impacto futuro.
-   Mantener los diagramas actualizados cuando cambie la arquitectura o
    el modelo de datos.

## 3.6 Estrategia de calidad

La calidad se evaluará con pruebas automatizadas y validación funcional
frente a los requerimientos y reglas de negocio acordados. Las métricas
cuantitativas de rendimiento y disponibilidad se definirán cuando exista
una necesidad verificable.

### Tipos de pruebas

| Tipo                             | Objetivo                                                | Ejemplos de alcance                                                                                   |
| -------------------------------- | ------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| Unitarias                        | Verificar reglas aisladas y cálculos                    | Totales, descuentos de NC, ahorro, utilidad y cantidades recomendadas una vez definidas las fórmulas. |
| Integración                      | Verificar la interacción entre servicios y persistencia | Creación/actualización de PV y productos, restricciones de datos y persistencia de propuestas.        |
| E2E de API                       | Validar flujos completos mediante HTTP                  | Autenticación, aislamiento de datos por usuario, creación y confirmación de una propuesta de pedido.  |
| Componentes/UI                   | Verificar el comportamiento de la interfaz              | Validación de formularios, mensajes, estados de carga y navegación de flujos críticos.                |
| Regresión manual multiplataforma | Detectar diferencias relevantes entre plataformas       | Flujos principales en Android, iOS y web; generación del PDF y manejo de errores.                     |
| Seguridad básica                 | Verificar controles esenciales                          | Acceso a recursos de otro usuario, manejo de sesión, exposición de secretos y validación de entradas. |


### Herramientas

-   Jest para pruebas unitarias y, según configuración, pruebas del
    backend y cliente.
-   Supertest para pruebas HTTP de integración/e2e del backend.
-   React Native Testing Library para componentes e interacción del
    cliente.
-   GitHub Actions para ejecutar verificaciones automatizadas en cambios
    relevantes.
-   ESLint, Prettier y TypeScript para detectar problemas de calidad
    estática antes de integrar cambios.

### Criterios de calidad

Una funcionalidad podrá considerarse terminada cuando:

1.  Cumpla los criterios de aceptación definidos para el requerimiento.
2.  Valide los datos obligatorios y gestione los errores previsibles.
3.  Respete la autenticación y el aislamiento de datos entre usuarios.
4.  Incluya pruebas automatizadas apropiadas para el riesgo de la
    funcionalidad.
5.  No introduzca errores de linting ni de comprobación de tipos.
6.  Mantenga la documentación necesaria actualizada.
7.  Se haya comprobado en las plataformas objetivo cuando el
    comportamiento pueda variar entre ellas.

### Validación de reglas de negocio

Los cálculos de recomendación, nota de crédito, ahorro, costos y
utilidad requieren validación explícita antes de usarse como base de
aceptación. Mientras existan fórmulas o reglas pendientes, se
documentarán como decisiones abiertas y no se presentarán como
comportamiento definitivo.

La validación funcional se realizará comparando escenarios de prueba con
resultados esperados confirmados por el usuario del negocio. Se
priorizarán los casos límite, como cantidades en cero, valores
inválidos, descuentos opcionales, cambios de precio y propuestas sin
nota de crédito.

### Alcance de calidad para el MVP

La prioridad es la corrección de los flujos principales, la integridad
de los datos, la seguridad básica y una experiencia de uso clara. No se
fijarán objetivos artificiales de cobertura de código ni pruebas de
carga complejas sin una necesidad real. La cobertura podrá usarse como
indicador auxiliar, pero no sustituye la calidad de los casos de prueba.

## 3.7 Metodología de trabajo

Se utilizará un enfoque **Kanban ligero con planificación iterativa**,
adecuado para un proyecto desarrollado principalmente por una sola
persona. No se implementará Scrum formal con ceremonias que no aporten
valor en este contexto.

### Flujo de trabajo

El trabajo se gestionará en un tablero con las siguientes columnas:

1.  **Backlog:** necesidades, errores y mejoras pendientes.
2.  **Ready:** elementos suficientemente claros para comenzar.
3.  **In progress:** trabajo en desarrollo, limitando el trabajo
    simultáneo.
4.  **Review / Validation:** revisión de código, pruebas y validación
    funcional.
5.  **Done:** cumple la definición de terminado.

Si una tarea requiere aclaraciones de negocio, se mantendrá bloqueada o
en el backlog hasta que la decisión esté registrada; no se ocultará la
incertidumbre mediante supuestos técnicos.

### Priorización y planificación

-   Priorizar primero los flujos necesarios para demostrar el valor
    central de la aplicación.
-   Dividir funcionalidades grandes en tareas pequeñas con resultados
    verificables.
-   Planificar por iteraciones cortas, revisando el avance y ajustando
    prioridades según el aprendizaje obtenido.
-   Atender primero las dependencias que puedan bloquear el desarrollo,
    como el modelo de datos y las fórmulas comerciales.
-   Mantener separadas las funcionalidades del MVP de mejoras
    posteriores, como la operación sin conexión en dispositivos móviles.
-   Registrar las decisiones importantes y los requisitos aún pendientes
    de definición.

### Seguimiento

El avance se medirá principalmente por funcionalidades terminadas y
verificadas, no por cantidad de horas ni por cantidad de tareas
iniciadas. En cada revisión se identificarán:

-   Trabajo completado y validado.
-   Bloqueos y decisiones de negocio pendientes.
-   Riesgos técnicos o de experiencia de usuario.
-   Próximo conjunto de tareas prioritarias.

### Definición de terminado (Definition of Done)

Una tarea estará terminada cuando:

-   El comportamiento implementado coincida con los criterios de
    aceptación.
-   Las validaciones y el manejo de errores relevantes estén incluidos.
-   Las pruebas apropiadas pasen localmente.
-   El linting y la comprobación de tipos pasen.
-   Se haya comprobado el flujo afectado en la plataforma
    correspondiente.
-   La documentación se actualice si cambió una decisión, configuración,
    regla o procedimiento.
-   Los cambios estén guardados en Git con un commit descriptivo.
-   No queden secretos, datos de prueba sensibles ni errores conocidos
    que impidan el uso correcto de la funcionalidad.

### Gestión de cambios y decisiones

Los nuevos requerimientos se evaluarán según su valor, costo, riesgo y
efecto sobre el alcance del MVP. Las decisiones técnicas importantes se
registrarán en notas o ADRs breves, incluyendo el contexto, la decisión
y sus consecuencias. Las reglas de negocio que todavía no hayan sido
confirmadas se mantendrán explícitamente como pendientes.

### Fuera del alcance metodológico del MVP

No se establecerán procesos formales de gestión de cambios, reuniones
recurrentes ni documentación extensa si el costo supera el beneficio
para un proyecto de este tamaño. La prioridad será mantener trazabilidad
suficiente para que el proyecto sea comprensible, verificable y
presentable como parte del portafolio.
