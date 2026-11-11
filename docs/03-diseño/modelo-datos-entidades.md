# Modelo de datos — documentación de entidades

> Esquema `core` · PostgreSQL · Prisma 7.10.1
> Fuente: `prisma/schema.prisma` y migración `20261109173055_init`.
> Documento generado desde la base de datos el 2026-11-09.

Los nombres de tabla y columna están en `snake_case`; los modelos y campos Prisma
usan `PascalCase`/`camelCase` con `@@map`/`@map`. Los usuarios, marcas, productos y
pedidos usan baja lógica mediante `deleted_at`; no se borran físicamente.

Notas:

- `created_at` usa `CURRENT_TIMESTAMP` en la base.
- `updated_at` lo mantiene Prisma Client (`@updatedAt`); no tiene DEFAULT en PostgreSQL.
- `session.family_id` se genera en Prisma Client (`@default(uuid())`); la columna no tiene DEFAULT.
- Los `@@unique` de Prisma se implementan como índices únicos (`CREATE UNIQUE INDEX`),
  no como constraints de tabla; por eso aparecen en la sección **Índices** de cada entidad.

## Resumen

| #   | Tabla                                                           | Propósito                                                                                      | Columnas | FKs salientes | FKs entrantes |
| --- | --------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- | -------: | ------------: | ------------: |
| 1   | [`company`](#company)                                           | Empresa propietaria de una o más marcas.                                                       |        6 |             0 |             1 |
| 2   | [`app_user`](#app_user)                                         | Usuario del sistema (agente de ventas o administrador).                                        |        9 |             0 |             6 |
| 3   | [`product_category`](#product_category)                         | Categoría comercial que agrupa productos.                                                      |        6 |             0 |             1 |
| 4   | [`rate_tax`](#rate_tax)                                         | Tarifa de impuesto configurada (por ejemplo, IVA).                                             |        7 |             0 |             1 |
| 5   | [`brand`](#brand)                                               | Marca comercial que agrupa productos de una empresa.                                           |        7 |             1 |             1 |
| 6   | [`session`](#session)                                           | Sesión de autenticación emitida tras un inicio de sesión exitoso.                              |       12 |             2 |             1 |
| 7   | [`auth_provider`](#auth_provider)                               | Credencial o vínculo de identidad externa de un usuario.                                       |        8 |             1 |             0 |
| 8   | [`sales_point`](#sales_point)                                   | Punto de venta atendido por un agente (tienda, puesto o cliente mayorista).                    |       11 |             1 |             3 |
| 9   | [`product`](#product)                                           | Producto comercializable del catálogo.                                                         |       13 |             3 |             3 |
| 10  | [`sales_target`](#sales_target)                                 | Meta de venta asignada a un agente para un periodo.                                            |        9 |             1 |             1 |
| 11  | [`product_price_history`](#product_price_history)               | Historial de precios de un producto por vigencia.                                              |        8 |             1 |             0 |
| 12  | [`sales_point_inventory_review`](#sales_point_inventory_review) | Revisión de inventario realizada por un agente en un punto de venta.                           |        7 |             2 |             2 |
| 13  | [`product_item`](#product_item)                                 | Detalle de inventario de un producto dentro de una revisión.                                   |       10 |             2 |             0 |
| 14  | [`sales_target_distribution`](#sales_target_distribution)       | Reparto de una meta de venta entre los puntos de venta del agente.                             |        8 |             2 |             0 |
| 15  | [`sales_order`](#sales_order)                                   | Pedido de venta registrado en un punto de venta; los totales se reconstruyen desde sus líneas. |       13 |             3 |             1 |
| 16  | [`sales_order_item`](#sales_order_item)                         | Línea de pedido: un producto con cantidad, precio y descuento.                                 |       12 |             2 |             0 |

## Jerarquía de dependencias

```text
N0  company · app_user · product_category · rate_tax
N1  brand · session · auth_provider · sales_point · product
N2  sales_target · product_price_history · sales_point_inventory_review · product_item
N3  sales_target_distribution · sales_order
N4  sales_order_item
```

Cada nivel depende de los anteriores. La única auto-relación es
`session.replace_by_id → session.id`.

## Enums

| Enum                         | Valores                    | Propósito                                                  |
| ---------------------------- | -------------------------- | ---------------------------------------------------------- |
| `auth_provider_provider`     | `google`, `local`          | Mecanismo de autenticación habilitado para un usuario.     |
| `status`                     | `active`, `deactived`      | Estado lógico de un registro que requiere ciclo de vida.   |
| `sales_point_category`       | `small`, `medium`, `large` | Clasificación del punto de venta por volumen de operación. |
| `product_unit_of_measure`    | `kilograms`, `grams`       | Unidad de medida con la que se comercializa un producto.   |
| `sales_order_payment_method` | `cash`, `credit`           | Forma de pago acordada para un pedido.                     |

## company

**Propósito:** Empresa propietaria de una o más marcas.

### Columnas

| Columna      | Tipo                          | Nulo  | Default           | Descripción                          |
| ------------ | ----------------------------- | :---: | ----------------- | ------------------------------------ |
| `id`         | `integer`                     |  no   | serial            | Identificador interno (PK).          |
| `code`       | `character varying(50)`       |  no   | —                 | Código interno de la empresa; único. |
| `name`       | `character varying(150)`      |  no   | —                 | Nombre comercial.     |
| `created_at` | `timestamp(6) with time zone` |  no   | CURRENT_TIMESTAMP | Fecha de creación del registro.      |
| `updated_at` | `timestamp(6) with time zone` |  no   | —                 | Fecha de la última modificación.     |
| `deleted_at` | `timestamp(6) with time zone` |  sí   | —                 | Fecha de baja lógica (soft delete).  |

### Constraints

| Nombre          | Tipo        | Definición         |
| --------------- | ----------- | ------------------ |
| `pk_company_id` | PRIMARY KEY | `PRIMARY KEY (id)` |

### Índices

| Nombre            | Único | Columnas |
| ----------------- | :---: | -------- |
| `uq_company_code` |  sí   | `code`   |

### Relaciones entrantes

- `brand.company_id` → `company(id)` · onDelete **CASCADE** · onUpdate **CASCADE** (`fk_brand_company_id_company_id`)

## app_user

**Propósito:** Usuario del sistema (agente de ventas).

### Columnas

| Columna             | Tipo                          | Nulo  | Default           | Descripción                                             |
| ------------------- | ----------------------------- | :---: | ----------------- | ------------------------------------------------------- |
| `id`                | `integer`                     |  no   | serial            | Identificador interno (PK).                             |
| `email`             | `character varying(255)`      |  no   | —                 | Correo electrónico de acceso; único en todo el sistema. |
| `first_name`        | `character varying(100)`      |  no   | —                 | Nombres de la persona.                                  |
| `last_name`         | `character varying(100)`      |  no   | —                 | Apellidos de la persona.                                |
| `phone`             | `character varying(30)`       |  sí   | —                 | Teléfono de contacto.                                   |
| `email_verified_at` | `timestamp(6) with time zone` |  sí   | —                 | Fecha en que se confirmó el correo electrónico.         |
| `created_at`        | `timestamp(6) with time zone` |  no   | CURRENT_TIMESTAMP | Fecha de creación del registro.                         |
| `updated_at`        | `timestamp(6) with time zone` |  no   | —                 | Fecha de la última modificación.                        |
| `deleted_at`        | `timestamp(6) with time zone` |  sí   | —                 | Fecha de baja lógica (soft delete).                     |

### Constraints

| Nombre           | Tipo        | Definición         |
| ---------------- | ----------- | ------------------ |
| `pk_app_user_id` | PRIMARY KEY | `PRIMARY KEY (id)` |

### Índices

| Nombre              | Único | Columnas |
| ------------------- | :---: | -------- |
| `uq_app_user_email` |  sí   | `email`  |

### Relaciones entrantes

- `auth_provider.user_id` → `app_user(id)` · onDelete **CASCADE** · onUpdate **CASCADE** (`fk_auth_provider_user_id_app_user_id`)
- `sales_order.sales_agent_id` → `app_user(id)` · onDelete **RESTRICT** · onUpdate **CASCADE** (`fk_sales_order_sales_agent_id_app_user_id`)
- `sales_point.sales_agent_id` → `app_user(id)` · onDelete **RESTRICT** · onUpdate **CASCADE** (`fk_sales_point_sales_agent_id_app_user_id`)
- `sales_point_inventory_review.sales_agent_id` → `app_user(id)` · onDelete **RESTRICT** · onUpdate **CASCADE** (`fk_sp_inventory_review_sales_agent_id_app_user_id`)
- `sales_target.sales_agent_id` → `app_user(id)` · onDelete **CASCADE** · onUpdate **CASCADE** (`fk_sales_target_sales_agent_id_app_user_id`)
- `session.user_id` → `app_user(id)` · onDelete **CASCADE** · onUpdate **CASCADE** (`fk_session_user_id_app_user_id`)

## product_category

**Propósito:** Categoría comercial que agrupa productos.

### Columnas

| Columna       | Tipo                          | Nulo  | Default           | Descripción                           |
| ------------- | ----------------------------- | :---: | ----------------- | ------------------------------------- |
| `id`          | `integer`                     |  no   | serial            | Identificador interno (PK).           |
| `name`        | `character varying(100)`      |  no   | —                 | Nombre de la categoría; único.        |
| `description` | `text`                        |  sí   | —                 | Descripción opcional de la categoría. |
| `created_at`  | `timestamp(6) with time zone` |  no   | CURRENT_TIMESTAMP | Fecha de creación del registro.       |
| `updated_at`  | `timestamp(6) with time zone` |  no   | —                 | Fecha de la última modificación.      |
| `deleted_at`  | `timestamp(6) with time zone` |  sí   | —                 | Fecha de baja lógica (soft delete).   |

### Constraints

| Nombre                   | Tipo        | Definición         |
| ------------------------ | ----------- | ------------------ |
| `pk_product_category_id` | PRIMARY KEY | `PRIMARY KEY (id)` |

### Índices

| Nombre                     | Único | Columnas |
| -------------------------- | :---: | -------- |
| `uq_product_category_name` |  sí   | `name`   |

### Relaciones entrantes

- `product.category_id` → `product_category(id)` · onDelete **RESTRICT** · onUpdate **CASCADE** (`fk_product_category_id_product_category_id`)

## rate_tax

**Propósito:** Tarifa de impuesto configurada (por ejemplo, IVA).

### Columnas

| Columna         | Tipo                          | Nulo  | Default           | Descripción                                    |
| --------------- | ----------------------------- | :---: | ----------------- | ---------------------------------------------- |
| `id`            | `integer`                     |  no   | serial            | Identificador interno (PK).                    |
| `hacienda_code` | `character varying(50)`       |  no   | —                 | Código de tarifa definido por Hacienda; único. |
| `name`          | `character varying(150)`      |  no   | —                 | Nombre descriptivo de la tarifa.               |
| `percentage`    | `numeric(5,2)`                |  no   | —                 | Porcentaje aplicable (0.00 a 100.00).          |
| `created_at`    | `timestamp(6) with time zone` |  no   | CURRENT_TIMESTAMP | Fecha de creación del registro.                |
| `updated_at`    | `timestamp(6) with time zone` |  no   | —                 | Fecha de la última modificación.               |
| `deleted_at`    | `timestamp(6) with time zone` |  sí   | —                 | Fecha de baja lógica (soft delete).            |

### Constraints

| Nombre           | Tipo        | Definición         |
| ---------------- | ----------- | ------------------ |
| `pk_rate_tax_id` | PRIMARY KEY | `PRIMARY KEY (id)` |

### Índices

| Nombre                      | Único | Columnas        |
| --------------------------- | :---: | --------------- |
| `uq_rate_tax_hacienda_code` |  sí   | `hacienda_code` |

### Relaciones entrantes

- `product.rate_tax_id` → `rate_tax(id)` · onDelete **RESTRICT** · onUpdate **CASCADE** (`fk_product_rate_tax_id_rate_tax_id`)

## brand

**Propósito:** Marca comercial que agrupa productos de una empresa.

### Columnas

| Columna       | Tipo                          | Nulo  | Default           | Descripción                            |
| ------------- | ----------------------------- | :---: | ----------------- | -------------------------------------- |
| `id`          | `integer`                     |  no   | serial            | Identificador interno (PK).            |
| `company_id`  | `integer`                     |  no   | —                 | Empresa propietaria de la marca.       |
| `name`        | `character varying(150)`      |  no   | —                 | Nombre de la marca; único por empresa. |
| `description` | `text`                        |  sí   | —                 | Descripción opcional de la marca.      |
| `created_at`  | `timestamp(6) with time zone` |  no   | CURRENT_TIMESTAMP | Fecha de creación del registro.        |
| `updated_at`  | `timestamp(6) with time zone` |  no   | —                 | Fecha de la última modificación.       |
| `deleted_at`  | `timestamp(6) with time zone` |  sí   | —                 | Fecha de baja lógica (soft delete).    |

### Constraints

| Nombre                           | Tipo        | Definición                                                                 |
| -------------------------------- | ----------- | -------------------------------------------------------------------------- |
| `fk_brand_company_id_company_id` | FOREIGN KEY | `company_id` → `company(id)` · onDelete **CASCADE** · onUpdate **CASCADE** |
| `pk_brand_id`                    | PRIMARY KEY | `PRIMARY KEY (id)`                                                         |

### Índices

| Nombre                     | Único | Columnas           |
| -------------------------- | :---: | ------------------ |
| `uq_brand_company_id_name` |  sí   | `company_id, name` |

### Relaciones entrantes

- `product.brand_id` → `brand(id)` · onDelete **RESTRICT** · onUpdate **CASCADE** (`fk_product_brand_id_brand_id`)

## session

**Propósito:** Sesión de autenticación emitida tras un inicio de sesión exitoso.

### Columnas

| Columna         | Tipo                          | Nulo  | Default           | Descripción                                                        |
| --------------- | ----------------------------- | :---: | ----------------- | ------------------------------------------------------------------ |
| `id`            | `integer`                     |  no   | serial            | Identificador interno (PK).                                        |
| `user_id`       | `integer`                     |  no   | —                 | Usuario dueño de la sesión.                                        |
| `token_hash`    | `character varying(255)`      |  no   | —                 | Hash del token de sesión; único y nunca se expone en claro.        |
| `family_id`     | `uuid`                        |  no   | —                 | Identificador de la familia de tokens para detectar reutilización. |
| `replace_by_id` | `integer`                     |  sí   | —                 | Sesión que reemplazó a esta durante una rotación.                  |
| `expires_at`    | `timestamp(6) with time zone` |  no   | —                 | Momento de expiración del token.                                   |
| `revoked_at`    | `timestamp(6) with time zone` |  sí   | —                 | Momento de revocación explícita (logout o detección de abuso).     |
| `ip_address`    | `inet`                        |  sí   | —                 | Dirección IP desde la que se emitió la sesión.                     |
| `user_agent`    | `character varying(255)`      |  sí   | —                 | User-Agent capturado en la emisión.                                |
| `last_used_at`  | `timestamp(6) with time zone` |  sí   | —                 | Último uso registrado del token.                                   |
| `created_at`    | `timestamp(6) with time zone` |  no   | CURRENT_TIMESTAMP | Fecha de creación del registro.                                    |
| `deleted_at`    | `timestamp(6) with time zone` |  sí   | —                 | Fecha de baja lógica (soft delete).                                |

### Constraints

| Nombre                                | Tipo        | Definición                                                                     |
| ------------------------------------- | ----------- | ------------------------------------------------------------------------------ |
| `fk_session_replace_by_id_session_id` | FOREIGN KEY | `replace_by_id` → `session(id)` · onDelete **SET NULL** · onUpdate **CASCADE** |
| `fk_session_user_id_app_user_id`      | FOREIGN KEY | `user_id` → `app_user(id)` · onDelete **CASCADE** · onUpdate **CASCADE**       |
| `pk_session_id`                       | PRIMARY KEY | `PRIMARY KEY (id)`                                                             |

### Índices

| Nombre                      | Único | Columnas        |
| --------------------------- | :---: | --------------- |
| `idx_session_expires_at`    |  no   | `expires_at`    |
| `idx_session_family_id`     |  no   | `family_id`     |
| `idx_session_replace_by_id` |  no   | `replace_by_id` |
| `idx_session_user_id`       |  no   | `user_id`       |
| `uq_session_token_hash`     |  sí   | `token_hash`    |

### Relaciones entrantes

- `session.replace_by_id` → `session(id)` · onDelete **SET NULL** · onUpdate **CASCADE** (`fk_session_replace_by_id_session_id`)

## auth_provider

**Propósito:** Credencial o vínculo de identidad externa de un usuario.

### Columnas

| Columna            | Tipo                          | Nulo  | Default           | Descripción                                                        |
| ------------------ | ----------------------------- | :---: | ----------------- | ------------------------------------------------------------------ |
| `id`               | `integer`                     |  no   | serial            | Identificador interno (PK).                                        |
| `user_id`          | `integer`                     |  no   | —                 | Usuario al que pertenece la credencial.                            |
| `provider`         | `core.auth_provider_provider` |  no   | —                 | Proveedor de autenticación utilizado.                              |
| `provider_user_id` | `character varying(255)`      |  sí   | —                 | Identificador del usuario en el proveedor externo (nulo en LOCAL). |
| `password_hash`    | `character varying(255)`      |  sí   | —                 | Hash de contraseña (solo proveedor LOCAL).                         |
| `created_at`       | `timestamp(6) with time zone` |  no   | CURRENT_TIMESTAMP | Fecha de creación del registro.                                    |
| `updated_at`       | `timestamp(6) with time zone` |  no   | —                 | Fecha de la última modificación.                                   |
| `deleted_at`       | `timestamp(6) with time zone` |  sí   | —                 | Fecha de baja lógica (soft delete).                                |

### Constraints

| Nombre                                 | Tipo        | Definición                                                               |
| -------------------------------------- | ----------- | ------------------------------------------------------------------------ |
| `fk_auth_provider_user_id_app_user_id` | FOREIGN KEY | `user_id` → `app_user(id)` · onDelete **CASCADE** · onUpdate **CASCADE** |
| `pk_auth_provider_id`                  | PRIMARY KEY | `PRIMARY KEY (id)`                                                       |

### Índices

| Nombre                                       | Único | Columnas                     |
| -------------------------------------------- | :---: | ---------------------------- |
| `uq_auth_provider_provider_provider_user_id` |  sí   | `provider, provider_user_id` |
| `uq_auth_provider_user_id_provider`          |  sí   | `user_id, provider`          |

### Relaciones entrantes

Sin referencias entrantes.

## sales_point

**Propósito:** Punto de venta atendido por un agente (tienda, puesto o cliente mayorista).

### Columnas

| Columna          | Tipo                          | Nulo  | Default           | Descripción                                              |
| ---------------- | ----------------------------- | :---: | ----------------- | -------------------------------------------------------- |
| `id`             | `integer`                     |  no   | serial            | Identificador interno (PK).                              |
| `sales_agent_id` | `integer`                     |  no   | —                 | Agente de ventas responsable del punto.                  |
| `code`           | `character varying(50)`       |  sí   | —                 | Código comercial del punto; único cuando está informado. |
| `name`           | `character varying(150)`      |  no   | —                 | Nombre comercial del punto de venta.                     |
| `contact_name`   | `character varying(150)`      |  sí   | —                 | Persona de contacto en el punto.                         |
| `phone`          | `character varying(30)`       |  sí   | —                 | Teléfono de contacto.                                    |
| `address`        | `text`                        |  sí   | —                 | Dirección física del punto.                              |
| `category`       | `core.sales_point_category`   |  no   | —                 | Clasificación por volumen de operación.                  |
| `created_at`     | `timestamp(6) with time zone` |  no   | CURRENT_TIMESTAMP | Fecha de creación del registro.                          |
| `updated_at`     | `timestamp(6) with time zone` |  no   | —                 | Fecha de la última modificación.                         |
| `deleted_at`     | `timestamp(6) with time zone` |  sí   | —                 | Fecha de baja lógica (soft delete).                      |

### Constraints

| Nombre                                      | Tipo        | Definición                                                                       |
| ------------------------------------------- | ----------- | -------------------------------------------------------------------------------- |
| `fk_sales_point_sales_agent_id_app_user_id` | FOREIGN KEY | `sales_agent_id` → `app_user(id)` · onDelete **RESTRICT** · onUpdate **CASCADE** |
| `pk_sales_point_id`                         | PRIMARY KEY | `PRIMARY KEY (id)`                                                               |

### Índices

| Nombre                           | Único | Columnas         |
| -------------------------------- | :---: | ---------------- |
| `idx_sales_point_sales_agent_id` |  no   | `sales_agent_id` |
| `uq_sales_point_code`            |  sí   | `code`           |

### Relaciones entrantes

- `sales_order.sales_point_id` → `sales_point(id)` · onDelete **RESTRICT** · onUpdate **CASCADE** (`fk_sales_order_sales_point_id_sales_point_id`)
- `sales_point_inventory_review.sales_point_id` → `sales_point(id)` · onDelete **CASCADE** · onUpdate **CASCADE** (`fk_sp_inventory_review_sales_point_id_sales_point_id`)
- `sales_target_distribution.sales_point_id` → `sales_point(id)` · onDelete **RESTRICT** · onUpdate **CASCADE** (`fk_sales_target_distribution_sales_point_id_sales_point_id`)

## product

**Propósito:** Producto comercializable del catálogo.

### Columnas

| Columna           | Tipo                           | Nulo  | Default           | Descripción                                        |
| ----------------- | ------------------------------ | :---: | ----------------- | -------------------------------------------------- |
| `id`              | `integer`                      |  no   | serial            | Identificador interno (PK).                        |
| `category_id`     | `integer`                      |  no   | —                 | Categoría comercial del producto.                  |
| `brand_id`        | `integer`                      |  no   | —                 | Marca del producto.                                |
| `rate_tax_id`     | `integer`                      |  no   | —                 | Tarifa de impuesto aplicable.                      |
| `name`            | `character varying(150)`       |  no   | —                 | Nombre comercial del producto.                     |
| `code`            | `character varying(50)`        |  no   | —                 | Código interno del producto; único.                |
| `commercial_code` | `character varying(50)`        |  sí   | —                 | Código usado por el área comercial o el proveedor. |
| `unit_of_measure` | `core.product_unit_of_measure` |  no   | —                 | Unidad de medida de comercialización.              |
| `weight`          | `numeric(10,3)`                |  no   | —                 | Peso del producto en la unidad indicada.           |
| `price`           | `numeric(12,2)`                |  no   | —                 | Precio de lista vigente.                           |
| `created_at`      | `timestamp(6) with time zone`  |  no   | CURRENT_TIMESTAMP | Fecha de creación del registro.                    |
| `updated_at`      | `timestamp(6) with time zone`  |  no   | —                 | Fecha de la última modificación.                   |
| `deleted_at`      | `timestamp(6) with time zone`  |  sí   | —                 | Fecha de baja lógica (soft delete).                |

### Constraints

| Nombre                                       | Tipo        | Definición                                                                            |
| -------------------------------------------- | ----------- | ------------------------------------------------------------------------------------- |
| `fk_product_brand_id_brand_id`               | FOREIGN KEY | `brand_id` → `brand(id)` · onDelete **RESTRICT** · onUpdate **CASCADE**               |
| `fk_product_category_id_product_category_id` | FOREIGN KEY | `category_id` → `product_category(id)` · onDelete **RESTRICT** · onUpdate **CASCADE** |
| `fk_product_rate_tax_id_rate_tax_id`         | FOREIGN KEY | `rate_tax_id` → `rate_tax(id)` · onDelete **RESTRICT** · onUpdate **CASCADE**         |
| `pk_product_id`                              | PRIMARY KEY | `PRIMARY KEY (id)`                                                                    |

### Índices

| Nombre                    | Único | Columnas      |
| ------------------------- | :---: | ------------- |
| `idx_product_brand_id`    |  no   | `brand_id`    |
| `idx_product_category_id` |  no   | `category_id` |
| `idx_product_rate_tax_id` |  no   | `rate_tax_id` |
| `uq_product_code`         |  sí   | `code`        |

### Relaciones entrantes

- `product_item.product_id` → `product(id)` · onDelete **RESTRICT** · onUpdate **CASCADE** (`fk_product_item_product_id_product_id`)
- `product_price_history.product_id` → `product(id)` · onDelete **CASCADE** · onUpdate **CASCADE** (`fk_product_price_history_product_id_product_id`)
- `sales_order_item.product_id` → `product(id)` · onDelete **RESTRICT** · onUpdate **CASCADE** (`fk_sales_order_item_product_id_product_id`)

## sales_target

**Propósito:** Meta de venta asignada a un agente para un periodo.

### Columnas

| Columna          | Tipo                          | Nulo  | Default           | Descripción                                |
| ---------------- | ----------------------------- | :---: | ----------------- | ------------------------------------------ |
| `id`             | `integer`                     |  no   | serial            | Identificador interno (PK).                |
| `sales_agent_id` | `integer`                     |  no   | —                 | Agente de ventas al que se asigna la meta. |
| `period_start`   | `date`                        |  no   | —                 | Inicio del periodo de la meta.             |
| `period_end`     | `date`                        |  no   | —                 | Fin del periodo de la meta.                |
| `target_amount`  | `numeric(12,2)`               |  no   | —                 | Monto objetivo del periodo.                |
| `status`         | `core.status`                 |  no   | —                 | Estado de la meta.                         |
| `created_at`     | `timestamp(6) with time zone` |  no   | CURRENT_TIMESTAMP | Fecha de creación del registro.            |
| `updated_at`     | `timestamp(6) with time zone` |  no   | —                 | Fecha de la última modificación.           |
| `deleted_at`     | `timestamp(6) with time zone` |  sí   | —                 | Fecha de baja lógica (soft delete).        |

### Constraints

| Nombre                                       | Tipo        | Definición                                                                      |
| -------------------------------------------- | ----------- | ------------------------------------------------------------------------------- |
| `fk_sales_target_sales_agent_id_app_user_id` | FOREIGN KEY | `sales_agent_id` → `app_user(id)` · onDelete **CASCADE** · onUpdate **CASCADE** |
| `pk_sales_target_id`                         | PRIMARY KEY | `PRIMARY KEY (id)`                                                              |

### Índices

| Nombre                                        | Único | Columnas                       |
| --------------------------------------------- | :---: | ------------------------------ |
| `uq_sales_target_sales_agent_id_period_start` |  sí   | `sales_agent_id, period_start` |

### Relaciones entrantes

- `sales_target_distribution.sales_target_id` → `sales_target(id)` · onDelete **CASCADE** · onUpdate **CASCADE** (`fk_sales_target_distribution_sales_target_id_sales_target_id`)

## product_price_history

**Propósito:** Historial de precios de un producto por vigencia.

### Columnas

| Columna      | Tipo                          | Nulo  | Default           | Descripción                                        |
| ------------ | ----------------------------- | :---: | ----------------- | -------------------------------------------------- |
| `id`         | `integer`                     |  no   | serial            | Identificador interno (PK).                        |
| `product_id` | `integer`                     |  no   | —                 | Producto al que corresponde el precio.             |
| `price`      | `numeric(12,2)`               |  no   | —                 | Precio vigente durante el intervalo.               |
| `valid_from` | `timestamp(6) with time zone` |  no   | —                 | Inicio de vigencia del precio.                     |
| `valid_to`   | `timestamp(6) with time zone` |  sí   | —                 | Fin de vigencia del precio; nulo si sigue vigente. |
| `created_at` | `timestamp(6) with time zone` |  no   | CURRENT_TIMESTAMP | Fecha de creación del registro.                    |
| `updated_at` | `timestamp(6) with time zone` |  no   | —                 | Fecha de la última modificación.                   |
| `deleted_at` | `timestamp(6) with time zone` |  sí   | —                 | Fecha de baja lógica (soft delete).                |

### Constraints

| Nombre                                           | Tipo        | Definición                                                                 |
| ------------------------------------------------ | ----------- | -------------------------------------------------------------------------- |
| `fk_product_price_history_product_id_product_id` | FOREIGN KEY | `product_id` → `product(id)` · onDelete **CASCADE** · onUpdate **CASCADE** |
| `pk_product_price_history_id`                    | PRIMARY KEY | `PRIMARY KEY (id)`                                                         |

### Índices

| Nombre                                           | Único | Columnas                 |
| ------------------------------------------------ | :---: | ------------------------ |
| `uq_product_price_history_product_id_valid_from` |  sí   | `product_id, valid_from` |

### Relaciones entrantes

Sin referencias entrantes.

## sales_point_inventory_review

**Propósito:** Revisión de inventario realizada por un agente en un punto de venta.

### Columnas

| Columna          | Tipo                          | Nulo  | Default           | Descripción                         |
| ---------------- | ----------------------------- | :---: | ----------------- | ----------------------------------- |
| `id`             | `integer`                     |  no   | serial            | Identificador interno (PK).         |
| `sales_point_id` | `integer`                     |  no   | —                 | Punto de venta revisado.            |
| `sales_agent_id` | `integer`                     |  no   | —                 | Agente que realizó la revisión.     |
| `visit_at`       | `timestamp(6) with time zone` |  no   | CURRENT_TIMESTAMP | Momento de la visita.               |
| `created_at`     | `timestamp(6) with time zone` |  no   | CURRENT_TIMESTAMP | Fecha de creación del registro.     |
| `updated_at`     | `timestamp(6) with time zone` |  no   | —                 | Fecha de la última modificación.    |
| `deleted_at`     | `timestamp(6) with time zone` |  sí   | —                 | Fecha de baja lógica (soft delete). |

### Constraints

| Nombre                                                 | Tipo        | Definición                                                                         |
| ------------------------------------------------------ | ----------- | ---------------------------------------------------------------------------------- |
| `fk_sp_inventory_review_sales_agent_id_app_user_id`    | FOREIGN KEY | `sales_agent_id` → `app_user(id)` · onDelete **RESTRICT** · onUpdate **CASCADE**   |
| `fk_sp_inventory_review_sales_point_id_sales_point_id` | FOREIGN KEY | `sales_point_id` → `sales_point(id)` · onDelete **CASCADE** · onUpdate **CASCADE** |
| `pk_sales_point_inventory_review_id`                   | PRIMARY KEY | `PRIMARY KEY (id)`                                                                 |

### Índices

| Nombre                                   | Único | Columnas         |
| ---------------------------------------- | :---: | ---------------- |
| `idx_sp_inventory_review_sales_agent_id` |  no   | `sales_agent_id` |
| `idx_sp_inventory_review_sales_point_id` |  no   | `sales_point_id` |

### Relaciones entrantes

- `product_item.inventory_review_id` → `sales_point_inventory_review(id)` · onDelete **CASCADE** · onUpdate **CASCADE** (`fk_product_item_inventory_review_id_sp_inventory_review_id`)
- `sales_order.inventory_review_id` → `sales_point_inventory_review(id)` · onDelete **SET NULL** · onUpdate **CASCADE** (`fk_sales_order_inventory_review_id_sp_inventory_review_id`)

## product_item

**Propósito:** Detalle de inventario de un producto dentro de una revisión.

### Columnas

| Columna                | Tipo                          | Nulo  | Default           | Descripción                                        |
| ---------------------- | ----------------------------- | :---: | ----------------- | -------------------------------------------------- |
| `id`                   | `integer`                     |  no   | serial            | Identificador interno (PK).                        |
| `inventory_review_id`  | `integer`                     |  no   | —                 | Revisión de inventario a la que pertenece el ítem. |
| `product_id`           | `integer`                     |  no   | —                 | Producto inventariado.                             |
| `warehouse_quantity`   | `integer`                     |  no   | —                 | Cantidad disponible en bodega.                     |
| `shelf_quantity`       | `integer`                     |  no   | —                 | Cantidad disponible en estantería.                 |
| `display_quantity`     | `integer`                     |  no   | —                 | Cantidad disponible en exhibición.                 |
| `recommended_quantity` | `integer`                     |  no   | —                 | Cantidad sugerida para reposición o pedido.        |
| `created_at`           | `timestamp(6) with time zone` |  no   | CURRENT_TIMESTAMP | Fecha de creación del registro.                    |
| `updated_at`           | `timestamp(6) with time zone` |  no   | —                 | Fecha de la última modificación.                   |
| `deleted_at`           | `timestamp(6) with time zone` |  sí   | —                 | Fecha de baja lógica (soft delete).                |

### Constraints

| Nombre                                                       | Tipo        | Definición                                                                                               |
| ------------------------------------------------------------ | ----------- | -------------------------------------------------------------------------------------------------------- |
| `fk_product_item_inventory_review_id_sp_inventory_review_id` | FOREIGN KEY | `inventory_review_id` → `sales_point_inventory_review(id)` · onDelete **CASCADE** · onUpdate **CASCADE** |
| `fk_product_item_product_id_product_id`                      | FOREIGN KEY | `product_id` → `product(id)` · onDelete **RESTRICT** · onUpdate **CASCADE**                              |
| `pk_product_item_id`                                         | PRIMARY KEY | `PRIMARY KEY (id)`                                                                                       |

### Índices

| Nombre                                           | Único | Columnas                          |
| ------------------------------------------------ | :---: | --------------------------------- |
| `idx_product_item_product_id`                    |  no   | `product_id`                      |
| `uq_product_item_inventory_review_id_product_id` |  sí   | `inventory_review_id, product_id` |

### Relaciones entrantes

Sin referencias entrantes.

## sales_target_distribution

**Propósito:** Reparto de una meta de venta entre los puntos de venta del agente.

### Columnas

| Columna                   | Tipo                          | Nulo  | Default           | Descripción                                      |
| ------------------------- | ----------------------------- | :---: | ----------------- | ------------------------------------------------ |
| `id`                      | `integer`                     |  no   | serial            | Identificador interno (PK).                      |
| `sales_target_id`         | `integer`                     |  no   | —                 | Meta de venta que se distribuye.                 |
| `sales_point_id`          | `integer`                     |  no   | —                 | Punto de venta que recibe la porción de la meta. |
| `distribution_percentage` | `numeric(5,2)`                |  no   | —                 | Porcentaje de la meta asignado al punto.         |
| `target_amount`           | `numeric(12,2)`               |  no   | —                 | Monto de la meta asignado al punto.              |
| `created_at`              | `timestamp(6) with time zone` |  no   | CURRENT_TIMESTAMP | Fecha de creación del registro.                  |
| `updated_at`              | `timestamp(6) with time zone` |  no   | —                 | Fecha de la última modificación.                 |
| `deleted_at`              | `timestamp(6) with time zone` |  sí   | —                 | Fecha de baja lógica (soft delete).              |

### Constraints

| Nombre                                                         | Tipo        | Definición                                                                           |
| -------------------------------------------------------------- | ----------- | ------------------------------------------------------------------------------------ |
| `fk_sales_target_distribution_sales_point_id_sales_point_id`   | FOREIGN KEY | `sales_point_id` → `sales_point(id)` · onDelete **RESTRICT** · onUpdate **CASCADE**  |
| `fk_sales_target_distribution_sales_target_id_sales_target_id` | FOREIGN KEY | `sales_target_id` → `sales_target(id)` · onDelete **CASCADE** · onUpdate **CASCADE** |
| `pk_sales_target_distribution_id`                              | PRIMARY KEY | `PRIMARY KEY (id)`                                                                   |

### Índices

| Nombre                                                        | Único | Columnas                          |
| ------------------------------------------------------------- | :---: | --------------------------------- |
| `idx_sales_target_distribution_sales_point_id`                |  no   | `sales_point_id`                  |
| `uq_sales_target_distribution_sales_target_id_sales_point_id` |  sí   | `sales_target_id, sales_point_id` |

### Relaciones entrantes

Sin referencias entrantes.

## sales_order

**Propósito:** Pedido de venta registrado en un punto de venta; los totales se reconstruyen desde sus líneas.

### Columnas

| Columna                | Tipo                              | Nulo  | Default           | Descripción                                              |
| ---------------------- | --------------------------------- | :---: | ----------------- | -------------------------------------------------------- |
| `id`                   | `integer`                         |  no   | serial            | Identificador interno (PK).                              |
| `sales_point_id`       | `integer`                         |  no   | —                 | Punto de venta donde se registra el pedido.              |
| `sales_agent_id`       | `integer`                         |  no   | —                 | Agente que registra el pedido.                           |
| `inventory_review_id`  | `integer`                         |  sí   | —                 | Revisión de inventario que originó el pedido (opcional). |
| `order_number`         | `character varying(50)`           |  no   | —                 | Número de pedido visible al negocio; único.              |
| `ordered_at`           | `timestamp(6) with time zone`     |  no   | —                 | Fecha y hora de registro del pedido.                     |
| `expected_delivery_at` | `timestamp(6) with time zone`     |  sí   | —                 | Fecha de entrega comprometida.                           |
| `payment_method`       | `core.sales_order_payment_method` |  no   | —                 | Forma de pago acordada.                                  |
| `fixed_space_fee`      | `numeric(12,2)`                   |  sí   | —                 | Cargo fijo por espacio acordado.                         |
| `percentage_space_fee` | `numeric(5,2)`                    |  sí   | —                 | Cargo porcentual por espacio acordado.                   |
| `created_at`           | `timestamp(6) with time zone`     |  no   | CURRENT_TIMESTAMP | Fecha de creación del registro.                          |
| `updated_at`           | `timestamp(6) with time zone`     |  no   | —                 | Fecha de la última modificación.                         |
| `deleted_at`           | `timestamp(6) with time zone`     |  sí   | —                 | Fecha de baja lógica (soft delete).                      |

### Constraints

| Nombre                                                      | Tipo        | Definición                                                                                                |
| ----------------------------------------------------------- | ----------- | --------------------------------------------------------------------------------------------------------- |
| `fk_sales_order_inventory_review_id_sp_inventory_review_id` | FOREIGN KEY | `inventory_review_id` → `sales_point_inventory_review(id)` · onDelete **SET NULL** · onUpdate **CASCADE** |
| `fk_sales_order_sales_agent_id_app_user_id`                 | FOREIGN KEY | `sales_agent_id` → `app_user(id)` · onDelete **RESTRICT** · onUpdate **CASCADE**                          |
| `fk_sales_order_sales_point_id_sales_point_id`              | FOREIGN KEY | `sales_point_id` → `sales_point(id)` · onDelete **RESTRICT** · onUpdate **CASCADE**                       |
| `pk_sales_order_id`                                         | PRIMARY KEY | `PRIMARY KEY (id)`                                                                                        |

### Índices

| Nombre                                | Único | Columnas              |
| ------------------------------------- | :---: | --------------------- |
| `idx_sales_order_inventory_review_id` |  no   | `inventory_review_id` |
| `idx_sales_order_sales_agent_id`      |  no   | `sales_agent_id`      |
| `idx_sales_order_sales_point_id`      |  no   | `sales_point_id`      |
| `uq_sales_order_order_number`         |  sí   | `order_number`        |

### Relaciones entrantes

- `sales_order_item.sales_order_id` → `sales_order(id)` · onDelete **CASCADE** · onUpdate **CASCADE** (`fk_sales_order_item_sales_order_id_sales_order_id`)

## sales_order_item

**Propósito:** Línea de pedido: un producto con cantidad, precio y descuento.

### Columnas

| Columna                 | Tipo                          | Nulo  | Default           | Descripción                                              |
| ----------------------- | ----------------------------- | :---: | ----------------- | -------------------------------------------------------- |
| `id`                    | `integer`                     |  no   | serial            | Identificador interno (PK).                              |
| `sales_order_id`        | `integer`                     |  no   | —                 | Pedido al que pertenece la línea.                        |
| `product_id`            | `integer`                     |  no   | —                 | Producto vendido.                                        |
| `quantity`              | `integer`                     |  no   | —                 | Cantidad pedida.                                         |
| `unit_price`            | `numeric(12,2)`               |  no   | —                 | Precio unitario de lista.                                |
| `unit_discounted_price` | `numeric(12,2)`               |  sí   | —                 | Precio unitario con descuento aplicado.                  |
| `subtotal_amount`       | `numeric(12,2)`               |  no   | —                 | Importe antes de descuento (cantidad x precio unitario). |
| `discount_amount`       | `numeric(12,2)`               |  no   | —                 | Descuento monetario aplicado a la línea.                 |
| `total_amount`          | `numeric(12,2)`               |  no   | —                 | Importe final de la línea.                               |
| `created_at`            | `timestamp(6) with time zone` |  no   | CURRENT_TIMESTAMP | Fecha de creación del registro.                          |
| `updated_at`            | `timestamp(6) with time zone` |  no   | —                 | Fecha de la última modificación.                         |
| `deleted_at`            | `timestamp(6) with time zone` |  sí   | —                 | Fecha de baja lógica (soft delete).                      |

### Constraints

| Nombre                                              | Tipo        | Definición                                                                         |
| --------------------------------------------------- | ----------- | ---------------------------------------------------------------------------------- |
| `fk_sales_order_item_product_id_product_id`         | FOREIGN KEY | `product_id` → `product(id)` · onDelete **RESTRICT** · onUpdate **CASCADE**        |
| `fk_sales_order_item_sales_order_id_sales_order_id` | FOREIGN KEY | `sales_order_id` → `sales_order(id)` · onDelete **CASCADE** · onUpdate **CASCADE** |
| `pk_sales_order_item_id`                            | PRIMARY KEY | `PRIMARY KEY (id)`                                                                 |

### Índices

| Nombre                                          | Único | Columnas                     |
| ----------------------------------------------- | :---: | ---------------------------- |
| `idx_sales_order_item_product_id`               |  no   | `product_id`                 |
| `uq_sales_order_item_sales_order_id_product_id` |  sí   | `sales_order_id, product_id` |

### Relaciones entrantes

Sin referencias entrantes.

