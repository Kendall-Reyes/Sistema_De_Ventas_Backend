# Estructura, configuración y cómo entender el proyecto

Este documento tiene como objetivo dejar claro cómo está organizado el backend `Sistema_De_Ventas_Backend`, qué archivos son clave, cómo está configurado y cómo probarlo.

## 1. Stack tecnológico

| Tecnología | Versión | Uso |
| --- | --- | --- |
| [NestJS](https://nestjs.com/) | ^12.0.1 | Framework backend modular y escalable con TypeScript |
| [TypeScript](https://www.typescriptlang.org/) | ^6.0.2 | Tipado estático |
| [Prisma](https://www.prisma.io/) | ^7.10.1 | ORM para acceso a base de datos |
| [PostgreSQL](https://www.postgresql.org/) | - | Base de datos relacional |
| [@prisma/adapter-pg](https://www.prisma.io/docs/orm/overview/databases/postgresql#using-the-node-postgres-driver) | ^7.10.1 | Adaptador de Prisma para pg |
| [pg](https://node-postgres.com/) | ^8.16.3 | Driver PostgreSQL |
| [RxJS](https://rxjs.dev/) | ^7.8.1 | Programación reactiva (core NestJS) |
| [class-validator / class-transformer](https://docs.nestjs.com/techniques/validation) | (via NestJS) | Validación y transformación de DTOs |
| [Vitest](https://vitest.dev/) | ^4.1.2 | Pruebas unitarias/e2e |
| [Supertest](https://github.com/ladjs/supertest) | ^7.0.0 | Pruebas HTTP e2e |
| [Oxlint](https://oxc.rs/docs/guide/usage/linter.html) | ^1.58.0 | Linting con soporte type-aware |
| [Prettier](https://prettier.io/) | ^3.4.2 | Formateado |

## 2. Requisitos para correr el proyecto

- **Node.js**: >= 18.x (compatible con TypeScript 6)
- **pnpm**: Usado en scripts/flujo del proyecto (ver `package.json`)
- **PostgreSQL**: Base de datos accesible para Prisma
- **Variables de entorno**: Configurar conexión a BD y configuración necesaria

## 3. Archivos de configuración clave

| Archivo | Propósito |
| --- | --- |
| `package.json` | Dependencias, scripts, tipo de módulo (`type: module`). Punto de partida. |
| `tsconfig.json` / `tsconfig.build.json` | Configuración de TypeScript para desarrollo y build. |
| `nest-cli.json` | Configuración del CLI de NestJS. |
| `prisma/schema.prisma` | Esquema de Prisma (modelos, relaciones, datasource). |
| `vitest.config.ts` / `vitest.config.e2e.ts` | Configuración de Vitest para unitarias y e2e. |
| `.oxlintrc.json` / configuración oxlint | Reglas de linting (type-aware). |
| `.prettierrc` | Formateo con Prettier. |
| `.env` / `.env.example` | Variables de entorno (conexión DB, etc.). |

## 4. Estructura de carpetas

La organización sigue un enfoque **modular por dominio/feature** con elementos transversales en `common/` y acceso a datos centralizado en `prisma/`.

```text
Sistema_De_Ventas_Backend/
├── prisma/                  # Configuración y servicio de Prisma
│   ├── prisma.module.ts     # Módulo global para Prisma
│   ├── prisma.service.ts    # Servicio con conexión a BD
│   └── schema.prisma        # Esquema de datos
├── src/
│   ├── app.module.ts        # Módulo raíz de la aplicación
│   ├── main.ts              # Punto de entrada (bootstrap)
│   ├── common/              # Elementos transversales reutilizables
│   │   ├── decorators/      # Decoradores personalizados
│   │   ├── dto/             # DTOs compartidos
│   │   ├── filters/         # Exception filters
│   │   ├── guards/          # Guards globales/compartidos
│   │   ├── interceptors/    # Interceptors
│   │   └── pipes/           # Pipes de validación/transformación
│   └── modules/             # Módulos por dominio de negocio
│       └── auth/            # Módulo de autenticación (referencia actual)
│           ├── auth.controller.ts  # Controlador HTTP
│           ├── auth.module.ts      # Definición del módulo
│           ├── auth.service.ts     # Lógica de negocio
│           ├── dto/                # DTOs específicos del módulo
│           ├── guards/             # Guards específicos
│           ├── repositories/       # Capa de acceso a datos
│           │   ├── auth.repository.ts        # Interfaz/contrato
│           │   └── prisma-auth.repository.ts # Implementación con Prisma
│           └── strategies/         # Estrategias de autenticación (Passport)
├── test/                    # Pruebas e2e
├── package.json
└── README.md
```

### Nota sobre arquitectura

- **`modules/`**: Agrupa funcionalidad por dominio de negocio. Cada módulo debe ser autocontenido cuando sea posible.
- **`common/`**: Código transversal sin lógica de negocio específica de un módulo. Debe ser genérico y reutilizable.
- **`prisma/`**: Centraliza la configuración del cliente Prisma. `PrismaService` se provee vía `PrismaModule` para inyección en repositorios/servicios.
- **`repositories/`**: Patrón de repositorio para desacoplar la lógica de negocio del acceso a datos. Se define un contrato (`*.repository.ts`) e implementación con Prisma (`prisma-*.repository.ts`).
- **`strategies/`**: Para autenticación (ej. JWT, local) siguiendo patrones de Passport/NestJS.

## 5. Cómo ejecutar el proyecto

### Primera vez

```bash
# Instalar dependencias
pnpm install

# Configurar variables de entorno
cp .env.example .env
# Ajustar DATABASE_URL y otras variables en .env

# Generar cliente Prisma
pnpm prisma:generate

# Ejecutar migraciones (desarrollo)
pnpm prisma:migrate
```

### Desarrollo

```bash
# Levantar en modo desarrollo con watch
pnpm start:dev

# Levantar en modo debug
pnpm start:debug

# Levantar en modo normal
pnpm start
```

La aplicación típicamente corre en `http://localhost:3000` (puerto por defecto de NestJS, configurable).

### Producción

```bash
# Compilar
pnpm build

# Ejecutar build
pnpm start:prod
```

### Calidad de código

```bash
# Linting
pnpm lint

# Formateo
pnpm format

# Pruebas unitarias
pnpm test
pnpm test:watch
pnpm test:cov

# Pruebas e2e
pnpm test:e2e
```

### Prisma

```bash
# Generar cliente
pnpm prisma:generate

# Crear/aplicar migración en dev
pnpm prisma:migrate

# Aplicar migraciones en prod
pnpm prisma:migrate:deploy

# Sincronizar schema con BD
pnpm prisma:push

# Abrir Prisma Studio
pnpm prisma:studio

# Traer schema desde BD
pnpm prisma:pull
```

## 6. Flujo actual para entender rápido

1. **Entry point**: `src/main.ts` arranca la aplicación NestJS.
2. **Módulo raíz**: `src/app.module.ts` registra módulos (incluye `PrismaModule` y módulos de dominio).
3. **Base de datos**: `PrismaModule`/`PrismaService` proveen acceso a Prisma. Cliente generado desde `prisma/schema.prisma`.
4. **Módulos de dominio**: Cada feature vive en `src/modules/<dominio>/` con `*.module.ts`, `*.controller.ts`, `*.service.ts`.
5. **Acceso a datos**: Usar patrón repositorio (`repositories/`) para aislar Prisma del servicio.
6. **Transversales**: `common/` para guards, filters, pipes, interceptors, decorators reutilizables.
7. **Pruebas**: Unitarias con Vitest, e2e en `test/` con Supertest.

## 7. Reglas prácticas para mantener la estructura

- **Módulos por negocio**: Crear `src/modules/<nombre-dominio>/` para nuevas capacidades (auth, products, sales, customers, etc.). Evitar carpetas genéricas `utils/` o `helpers/` fuera de `common/`.
- **Un módulo, una responsabilidad**: Mantener `controller`, `service`, `module` claros. Lógica compleja va en `service` o servicios auxiliares.
- **Repositorios**: Definir interfaz/contrato y usar implementación Prisma. Esto facilita testing y cambio de ORM si fuera necesario.
- **DTOs**: Usar `class-validator`/`class-transformer` para validar entrada/salida. Colocar DTOs en `dto/` del módulo o `common/dto/` si son compartidos.
- **Transversales primero**: Antes de duplicar, revisar `common/` (guards, filters, pipes, interceptors).
- **Prisma**: No instanciar PrismaClient manualmente. Siempre inyectar `PrismaService`.
- **Configuración**: Centralizar configuración sensible vía variables de entorno. No hardcodear credenciales.
- **Testing**: Escribir pruebas unitarias para servicios/lógica. Usar `test/` para flujos e2e completos.
- **TypeScript estricto**: Aprovechar tipado. Evitar `any` cuando sea posible.
- **Imports**: Mantener imports organizados. El proyecto usa ESM (`"type": "module"`).
