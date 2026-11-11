-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "core";

-- CreateEnum
CREATE TYPE "core"."auth_provider_provider" AS ENUM ('google', 'local');

-- CreateEnum
CREATE TYPE "core"."status" AS ENUM ('active', 'deactived');

-- CreateEnum
CREATE TYPE "core"."sales_point_category" AS ENUM ('small', 'medium', 'large');

-- CreateEnum
CREATE TYPE "core"."product_unit_of_measure" AS ENUM ('kilograms', 'grams');

-- CreateEnum
CREATE TYPE "core"."sales_order_payment_method" AS ENUM ('cash', 'credit');

-- CreateTable
CREATE TABLE "core"."app_user" (
    "id" SERIAL NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "first_name" VARCHAR(100) NOT NULL,
    "last_name" VARCHAR(100) NOT NULL,
    "phone" VARCHAR(30),
    "email_verified_at" TIMESTAMPTZ(6),
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "pk_app_user_id" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "core"."auth_provider" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "provider" "core"."auth_provider_provider" NOT NULL,
    "provider_user_id" VARCHAR(255),
    "password_hash" VARCHAR(255),
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "pk_auth_provider_id" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "core"."session" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "token_hash" VARCHAR(255) NOT NULL,
    "family_id" UUID NOT NULL,
    "replace_by_id" INTEGER,
    "expires_at" TIMESTAMPTZ(6) NOT NULL,
    "revoked_at" TIMESTAMPTZ(6),
    "ip_address" INET,
    "user_agent" VARCHAR(255),
    "last_used_at" TIMESTAMPTZ(6),
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "pk_session_id" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "core"."sales_point" (
    "id" SERIAL NOT NULL,
    "sales_agent_id" INTEGER NOT NULL,
    "code" VARCHAR(50),
    "name" VARCHAR(150) NOT NULL,
    "contact_name" VARCHAR(150),
    "phone" VARCHAR(30),
    "address" TEXT,
    "category" "core"."sales_point_category" NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "pk_sales_point_id" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "core"."sales_target" (
    "id" SERIAL NOT NULL,
    "sales_agent_id" INTEGER NOT NULL,
    "period_start" DATE NOT NULL,
    "period_end" DATE NOT NULL,
    "target_amount" DECIMAL(12,2) NOT NULL,
    "status" "core"."status" NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "pk_sales_target_id" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "core"."sales_target_distribution" (
    "id" SERIAL NOT NULL,
    "sales_target_id" INTEGER NOT NULL,
    "sales_point_id" INTEGER NOT NULL,
    "distribution_percentage" DECIMAL(5,2) NOT NULL,
    "target_amount" DECIMAL(12,2) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "pk_sales_target_distribution_id" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "core"."product_category" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "description" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "pk_product_category_id" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "core"."rate_tax" (
    "id" SERIAL NOT NULL,
    "hacienda_code" VARCHAR(50) NOT NULL,
    "name" VARCHAR(150) NOT NULL,
    "percentage" DECIMAL(5,2) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "pk_rate_tax_id" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "core"."product" (
    "id" SERIAL NOT NULL,
    "category_id" INTEGER NOT NULL,
    "brand_id" INTEGER NOT NULL,
    "rate_tax_id" INTEGER NOT NULL,
    "name" VARCHAR(150) NOT NULL,
    "code" VARCHAR(50) NOT NULL,
    "commercial_code" VARCHAR(50),
    "unit_of_measure" "core"."product_unit_of_measure" NOT NULL,
    "weight" DECIMAL(10,3) NOT NULL,
    "price" DECIMAL(12,2) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "pk_product_id" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "core"."product_price_history" (
    "id" SERIAL NOT NULL,
    "product_id" INTEGER NOT NULL,
    "price" DECIMAL(12,2) NOT NULL,
    "valid_from" TIMESTAMPTZ(6) NOT NULL,
    "valid_to" TIMESTAMPTZ(6),
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "pk_product_price_history_id" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "core"."company" (
    "id" SERIAL NOT NULL,
    "code" VARCHAR(50) NOT NULL,
    "name" VARCHAR(150) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "pk_company_id" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "core"."brand" (
    "id" SERIAL NOT NULL,
    "company_id" INTEGER NOT NULL,
    "name" VARCHAR(150) NOT NULL,
    "description" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "pk_brand_id" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "core"."sales_point_inventory_review" (
    "id" SERIAL NOT NULL,
    "sales_point_id" INTEGER NOT NULL,
    "sales_agent_id" INTEGER NOT NULL,
    "visit_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "pk_sales_point_inventory_review_id" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "core"."product_item" (
    "id" SERIAL NOT NULL,
    "inventory_review_id" INTEGER NOT NULL,
    "product_id" INTEGER NOT NULL,
    "warehouse_quantity" INTEGER NOT NULL,
    "shelf_quantity" INTEGER NOT NULL,
    "display_quantity" INTEGER NOT NULL,
    "recommended_quantity" INTEGER NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "pk_product_item_id" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "core"."sales_order" (
    "id" SERIAL NOT NULL,
    "sales_point_id" INTEGER NOT NULL,
    "sales_agent_id" INTEGER NOT NULL,
    "inventory_review_id" INTEGER,
    "order_number" VARCHAR(50) NOT NULL,
    "ordered_at" TIMESTAMPTZ(6) NOT NULL,
    "expected_delivery_at" TIMESTAMPTZ(6),
    "payment_method" "core"."sales_order_payment_method" NOT NULL,
    "fixed_space_fee" DECIMAL(12,2),
    "percentage_space_fee" DECIMAL(5,2),
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "pk_sales_order_id" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "core"."sales_order_item" (
    "id" SERIAL NOT NULL,
    "sales_order_id" INTEGER NOT NULL,
    "product_id" INTEGER NOT NULL,
    "quantity" INTEGER NOT NULL,
    "unit_price" DECIMAL(12,2) NOT NULL,
    "unit_discounted_price" DECIMAL(12,2),
    "subtotal_amount" DECIMAL(12,2) NOT NULL,
    "discount_amount" DECIMAL(12,2) NOT NULL,
    "total_amount" DECIMAL(12,2) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "pk_sales_order_item_id" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "uq_app_user_email" ON "core"."app_user"("email");

-- CreateIndex
CREATE UNIQUE INDEX "uq_auth_provider_user_id_provider" ON "core"."auth_provider"("user_id", "provider");

-- CreateIndex
CREATE UNIQUE INDEX "uq_auth_provider_provider_provider_user_id" ON "core"."auth_provider"("provider", "provider_user_id");

-- CreateIndex
CREATE UNIQUE INDEX "uq_session_token_hash" ON "core"."session"("token_hash");

-- CreateIndex
CREATE INDEX "idx_session_user_id" ON "core"."session"("user_id");

-- CreateIndex
CREATE INDEX "idx_session_family_id" ON "core"."session"("family_id");

-- CreateIndex
CREATE INDEX "idx_session_expires_at" ON "core"."session"("expires_at");

-- CreateIndex
CREATE INDEX "idx_session_replace_by_id" ON "core"."session"("replace_by_id");

-- CreateIndex
CREATE UNIQUE INDEX "uq_sales_point_code" ON "core"."sales_point"("code");

-- CreateIndex
CREATE INDEX "idx_sales_point_sales_agent_id" ON "core"."sales_point"("sales_agent_id");

-- CreateIndex
CREATE UNIQUE INDEX "uq_sales_target_sales_agent_id_period_start" ON "core"."sales_target"("sales_agent_id", "period_start");

-- CreateIndex
CREATE INDEX "idx_sales_target_distribution_sales_point_id" ON "core"."sales_target_distribution"("sales_point_id");

-- CreateIndex
CREATE UNIQUE INDEX "uq_sales_target_distribution_sales_target_id_sales_point_id" ON "core"."sales_target_distribution"("sales_target_id", "sales_point_id");

-- CreateIndex
CREATE UNIQUE INDEX "uq_product_category_name" ON "core"."product_category"("name");

-- CreateIndex
CREATE UNIQUE INDEX "uq_rate_tax_hacienda_code" ON "core"."rate_tax"("hacienda_code");

-- CreateIndex
CREATE UNIQUE INDEX "uq_product_code" ON "core"."product"("code");

-- CreateIndex
CREATE INDEX "idx_product_category_id" ON "core"."product"("category_id");

-- CreateIndex
CREATE INDEX "idx_product_brand_id" ON "core"."product"("brand_id");

-- CreateIndex
CREATE INDEX "idx_product_rate_tax_id" ON "core"."product"("rate_tax_id");

-- CreateIndex
CREATE UNIQUE INDEX "uq_product_price_history_product_id_valid_from" ON "core"."product_price_history"("product_id", "valid_from");

-- CreateIndex
CREATE UNIQUE INDEX "uq_company_code" ON "core"."company"("code");

-- CreateIndex
CREATE UNIQUE INDEX "uq_brand_company_id_name" ON "core"."brand"("company_id", "name");

-- CreateIndex
CREATE INDEX "idx_sp_inventory_review_sales_point_id" ON "core"."sales_point_inventory_review"("sales_point_id");

-- CreateIndex
CREATE INDEX "idx_sp_inventory_review_sales_agent_id" ON "core"."sales_point_inventory_review"("sales_agent_id");

-- CreateIndex
CREATE INDEX "idx_product_item_product_id" ON "core"."product_item"("product_id");

-- CreateIndex
CREATE UNIQUE INDEX "uq_product_item_inventory_review_id_product_id" ON "core"."product_item"("inventory_review_id", "product_id");

-- CreateIndex
CREATE UNIQUE INDEX "uq_sales_order_order_number" ON "core"."sales_order"("order_number");

-- CreateIndex
CREATE INDEX "idx_sales_order_sales_point_id" ON "core"."sales_order"("sales_point_id");

-- CreateIndex
CREATE INDEX "idx_sales_order_sales_agent_id" ON "core"."sales_order"("sales_agent_id");

-- CreateIndex
CREATE INDEX "idx_sales_order_inventory_review_id" ON "core"."sales_order"("inventory_review_id");

-- CreateIndex
CREATE INDEX "idx_sales_order_item_product_id" ON "core"."sales_order_item"("product_id");

-- CreateIndex
CREATE UNIQUE INDEX "uq_sales_order_item_sales_order_id_product_id" ON "core"."sales_order_item"("sales_order_id", "product_id");

-- AddForeignKey
ALTER TABLE "core"."auth_provider" ADD CONSTRAINT "fk_auth_provider_user_id_app_user_id" FOREIGN KEY ("user_id") REFERENCES "core"."app_user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."session" ADD CONSTRAINT "fk_session_user_id_app_user_id" FOREIGN KEY ("user_id") REFERENCES "core"."app_user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."session" ADD CONSTRAINT "fk_session_replace_by_id_session_id" FOREIGN KEY ("replace_by_id") REFERENCES "core"."session"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."sales_point" ADD CONSTRAINT "fk_sales_point_sales_agent_id_app_user_id" FOREIGN KEY ("sales_agent_id") REFERENCES "core"."app_user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."sales_target" ADD CONSTRAINT "fk_sales_target_sales_agent_id_app_user_id" FOREIGN KEY ("sales_agent_id") REFERENCES "core"."app_user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."sales_target_distribution" ADD CONSTRAINT "fk_sales_target_distribution_sales_target_id_sales_target_id" FOREIGN KEY ("sales_target_id") REFERENCES "core"."sales_target"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."sales_target_distribution" ADD CONSTRAINT "fk_sales_target_distribution_sales_point_id_sales_point_id" FOREIGN KEY ("sales_point_id") REFERENCES "core"."sales_point"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."product" ADD CONSTRAINT "fk_product_category_id_product_category_id" FOREIGN KEY ("category_id") REFERENCES "core"."product_category"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."product" ADD CONSTRAINT "fk_product_brand_id_brand_id" FOREIGN KEY ("brand_id") REFERENCES "core"."brand"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."product" ADD CONSTRAINT "fk_product_rate_tax_id_rate_tax_id" FOREIGN KEY ("rate_tax_id") REFERENCES "core"."rate_tax"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."product_price_history" ADD CONSTRAINT "fk_product_price_history_product_id_product_id" FOREIGN KEY ("product_id") REFERENCES "core"."product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."brand" ADD CONSTRAINT "fk_brand_company_id_company_id" FOREIGN KEY ("company_id") REFERENCES "core"."company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."sales_point_inventory_review" ADD CONSTRAINT "fk_sp_inventory_review_sales_point_id_sales_point_id" FOREIGN KEY ("sales_point_id") REFERENCES "core"."sales_point"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."sales_point_inventory_review" ADD CONSTRAINT "fk_sp_inventory_review_sales_agent_id_app_user_id" FOREIGN KEY ("sales_agent_id") REFERENCES "core"."app_user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."product_item" ADD CONSTRAINT "fk_product_item_inventory_review_id_sp_inventory_review_id" FOREIGN KEY ("inventory_review_id") REFERENCES "core"."sales_point_inventory_review"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."product_item" ADD CONSTRAINT "fk_product_item_product_id_product_id" FOREIGN KEY ("product_id") REFERENCES "core"."product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."sales_order" ADD CONSTRAINT "fk_sales_order_sales_point_id_sales_point_id" FOREIGN KEY ("sales_point_id") REFERENCES "core"."sales_point"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."sales_order" ADD CONSTRAINT "fk_sales_order_sales_agent_id_app_user_id" FOREIGN KEY ("sales_agent_id") REFERENCES "core"."app_user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."sales_order" ADD CONSTRAINT "fk_sales_order_inventory_review_id_sp_inventory_review_id" FOREIGN KEY ("inventory_review_id") REFERENCES "core"."sales_point_inventory_review"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."sales_order_item" ADD CONSTRAINT "fk_sales_order_item_sales_order_id_sales_order_id" FOREIGN KEY ("sales_order_id") REFERENCES "core"."sales_order"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."sales_order_item" ADD CONSTRAINT "fk_sales_order_item_product_id_product_id" FOREIGN KEY ("product_id") REFERENCES "core"."product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- ---------------------------------------------------------------------------
-- Documentación de objetos de base de datos (COMMENT ON)
-- ---------------------------------------------------------------------------

-- Comments: enum types
COMMENT ON TYPE "core"."auth_provider_provider" IS 'Mecanismo de autenticación habilitado para un usuario.';
COMMENT ON TYPE "core"."status" IS 'Estado lógico de un registro que requiere ciclo de vida.';
COMMENT ON TYPE "core"."sales_point_category" IS 'Clasificación del punto de venta por volumen de operación.';
COMMENT ON TYPE "core"."product_unit_of_measure" IS 'Unidad de medida con la que se comercializa un producto.';
COMMENT ON TYPE "core"."sales_order_payment_method" IS 'Forma de pago acordada para un pedido.';

-- Comments: app_user
COMMENT ON TABLE "core"."app_user" IS 'Usuario del sistema (agente de ventas o administrador).';
COMMENT ON COLUMN "core"."app_user"."id" IS 'Identificador interno (PK).';
COMMENT ON COLUMN "core"."app_user"."email" IS 'Correo electrónico de acceso; único en todo el sistema.';
COMMENT ON COLUMN "core"."app_user"."first_name" IS 'Nombres de la persona.';
COMMENT ON COLUMN "core"."app_user"."last_name" IS 'Apellidos de la persona.';
COMMENT ON COLUMN "core"."app_user"."phone" IS 'Teléfono de contacto.';
COMMENT ON COLUMN "core"."app_user"."email_verified_at" IS 'Fecha en que se confirmó el correo electrónico.';
COMMENT ON COLUMN "core"."app_user"."created_at" IS 'Fecha de creación del registro.';
COMMENT ON COLUMN "core"."app_user"."updated_at" IS 'Fecha de la última modificación.';
COMMENT ON COLUMN "core"."app_user"."deleted_at" IS 'Fecha de baja lógica (soft delete).';

-- Comments: auth_provider
COMMENT ON TABLE "core"."auth_provider" IS 'Credencial o vínculo de identidad externa de un usuario.';
COMMENT ON COLUMN "core"."auth_provider"."id" IS 'Identificador interno (PK).';
COMMENT ON COLUMN "core"."auth_provider"."user_id" IS 'Usuario al que pertenece la credencial.';
COMMENT ON COLUMN "core"."auth_provider"."provider" IS 'Proveedor de autenticación utilizado.';
COMMENT ON COLUMN "core"."auth_provider"."provider_user_id" IS 'Identificador del usuario en el proveedor externo (nulo en LOCAL).';
COMMENT ON COLUMN "core"."auth_provider"."password_hash" IS 'Hash de contraseña (solo proveedor LOCAL).';
COMMENT ON COLUMN "core"."auth_provider"."created_at" IS 'Fecha de creación del registro.';
COMMENT ON COLUMN "core"."auth_provider"."updated_at" IS 'Fecha de la última modificación.';
COMMENT ON COLUMN "core"."auth_provider"."deleted_at" IS 'Fecha de baja lógica (soft delete).';

-- Comments: session
COMMENT ON TABLE "core"."session" IS 'Sesión de autenticación emitida tras un inicio de sesión exitoso.';
COMMENT ON COLUMN "core"."session"."id" IS 'Identificador interno (PK).';
COMMENT ON COLUMN "core"."session"."user_id" IS 'Usuario dueño de la sesión.';
COMMENT ON COLUMN "core"."session"."token_hash" IS 'Hash del token de sesión; único y nunca se expone en claro.';
COMMENT ON COLUMN "core"."session"."family_id" IS 'Identificador de la familia de tokens para detectar reutilización.';
COMMENT ON COLUMN "core"."session"."replace_by_id" IS 'Sesión que reemplazó a esta durante una rotación.';
COMMENT ON COLUMN "core"."session"."expires_at" IS 'Momento de expiración del token.';
COMMENT ON COLUMN "core"."session"."revoked_at" IS 'Momento de revocación explícita (logout o detección de abuso).';
COMMENT ON COLUMN "core"."session"."ip_address" IS 'Dirección IP desde la que se emitió la sesión.';
COMMENT ON COLUMN "core"."session"."user_agent" IS 'User-Agent capturado en la emisión.';
COMMENT ON COLUMN "core"."session"."last_used_at" IS 'Último uso registrado del token.';
COMMENT ON COLUMN "core"."session"."created_at" IS 'Fecha de creación del registro.';
COMMENT ON COLUMN "core"."session"."deleted_at" IS 'Fecha de baja lógica (soft delete).';

-- Comments: sales_point
COMMENT ON TABLE "core"."sales_point" IS 'Punto de venta atendido por un agente (tienda, puesto o cliente mayorista).';
COMMENT ON COLUMN "core"."sales_point"."id" IS 'Identificador interno (PK).';
COMMENT ON COLUMN "core"."sales_point"."sales_agent_id" IS 'Agente de ventas responsable del punto.';
COMMENT ON COLUMN "core"."sales_point"."code" IS 'Código comercial del punto; único cuando está informado.';
COMMENT ON COLUMN "core"."sales_point"."name" IS 'Nombre comercial del punto de venta.';
COMMENT ON COLUMN "core"."sales_point"."contact_name" IS 'Persona de contacto en el punto.';
COMMENT ON COLUMN "core"."sales_point"."phone" IS 'Teléfono de contacto.';
COMMENT ON COLUMN "core"."sales_point"."address" IS 'Dirección física del punto.';
COMMENT ON COLUMN "core"."sales_point"."category" IS 'Clasificación por volumen de operación.';
COMMENT ON COLUMN "core"."sales_point"."created_at" IS 'Fecha de creación del registro.';
COMMENT ON COLUMN "core"."sales_point"."updated_at" IS 'Fecha de la última modificación.';
COMMENT ON COLUMN "core"."sales_point"."deleted_at" IS 'Fecha de baja lógica (soft delete).';

-- Comments: sales_target
COMMENT ON TABLE "core"."sales_target" IS 'Meta de venta asignada a un agente para un periodo.';
COMMENT ON COLUMN "core"."sales_target"."id" IS 'Identificador interno (PK).';
COMMENT ON COLUMN "core"."sales_target"."sales_agent_id" IS 'Agente de ventas al que se asigna la meta.';
COMMENT ON COLUMN "core"."sales_target"."period_start" IS 'Inicio del periodo de la meta.';
COMMENT ON COLUMN "core"."sales_target"."period_end" IS 'Fin del periodo de la meta.';
COMMENT ON COLUMN "core"."sales_target"."target_amount" IS 'Monto objetivo del periodo.';
COMMENT ON COLUMN "core"."sales_target"."status" IS 'Estado de la meta.';
COMMENT ON COLUMN "core"."sales_target"."created_at" IS 'Fecha de creación del registro.';
COMMENT ON COLUMN "core"."sales_target"."updated_at" IS 'Fecha de la última modificación.';
COMMENT ON COLUMN "core"."sales_target"."deleted_at" IS 'Fecha de baja lógica (soft delete).';

-- Comments: sales_target_distribution
COMMENT ON TABLE "core"."sales_target_distribution" IS 'Reparto de una meta de venta entre los puntos de venta del agente.';
COMMENT ON COLUMN "core"."sales_target_distribution"."id" IS 'Identificador interno (PK).';
COMMENT ON COLUMN "core"."sales_target_distribution"."sales_target_id" IS 'Meta de venta que se distribuye.';
COMMENT ON COLUMN "core"."sales_target_distribution"."sales_point_id" IS 'Punto de venta que recibe la porción de la meta.';
COMMENT ON COLUMN "core"."sales_target_distribution"."distribution_percentage" IS 'Porcentaje de la meta asignado al punto.';
COMMENT ON COLUMN "core"."sales_target_distribution"."target_amount" IS 'Monto de la meta asignado al punto.';
COMMENT ON COLUMN "core"."sales_target_distribution"."created_at" IS 'Fecha de creación del registro.';
COMMENT ON COLUMN "core"."sales_target_distribution"."updated_at" IS 'Fecha de la última modificación.';
COMMENT ON COLUMN "core"."sales_target_distribution"."deleted_at" IS 'Fecha de baja lógica (soft delete).';

-- Comments: product_category
COMMENT ON TABLE "core"."product_category" IS 'Categoría comercial que agrupa productos.';
COMMENT ON COLUMN "core"."product_category"."id" IS 'Identificador interno (PK).';
COMMENT ON COLUMN "core"."product_category"."name" IS 'Nombre de la categoría; único.';
COMMENT ON COLUMN "core"."product_category"."description" IS 'Descripción opcional de la categoría.';
COMMENT ON COLUMN "core"."product_category"."created_at" IS 'Fecha de creación del registro.';
COMMENT ON COLUMN "core"."product_category"."updated_at" IS 'Fecha de la última modificación.';
COMMENT ON COLUMN "core"."product_category"."deleted_at" IS 'Fecha de baja lógica (soft delete).';

-- Comments: rate_tax
COMMENT ON TABLE "core"."rate_tax" IS 'Tarifa de impuesto configurada (por ejemplo, IVA).';
COMMENT ON COLUMN "core"."rate_tax"."id" IS 'Identificador interno (PK).';
COMMENT ON COLUMN "core"."rate_tax"."hacienda_code" IS 'Código de tarifa definido por Hacienda; único.';
COMMENT ON COLUMN "core"."rate_tax"."name" IS 'Nombre descriptivo de la tarifa.';
COMMENT ON COLUMN "core"."rate_tax"."percentage" IS 'Porcentaje aplicable (0.00 a 100.00).';
COMMENT ON COLUMN "core"."rate_tax"."created_at" IS 'Fecha de creación del registro.';
COMMENT ON COLUMN "core"."rate_tax"."updated_at" IS 'Fecha de la última modificación.';
COMMENT ON COLUMN "core"."rate_tax"."deleted_at" IS 'Fecha de baja lógica (soft delete).';

-- Comments: product
COMMENT ON TABLE "core"."product" IS 'Producto comercializable del catálogo.';
COMMENT ON COLUMN "core"."product"."id" IS 'Identificador interno (PK).';
COMMENT ON COLUMN "core"."product"."category_id" IS 'Categoría comercial del producto.';
COMMENT ON COLUMN "core"."product"."brand_id" IS 'Marca del producto.';
COMMENT ON COLUMN "core"."product"."rate_tax_id" IS 'Tarifa de impuesto aplicable.';
COMMENT ON COLUMN "core"."product"."name" IS 'Nombre comercial del producto.';
COMMENT ON COLUMN "core"."product"."code" IS 'Código interno del producto; único.';
COMMENT ON COLUMN "core"."product"."commercial_code" IS 'Código usado por el área comercial o el proveedor.';
COMMENT ON COLUMN "core"."product"."unit_of_measure" IS 'Unidad de medida de comercialización.';
COMMENT ON COLUMN "core"."product"."weight" IS 'Peso del producto en la unidad indicada.';
COMMENT ON COLUMN "core"."product"."price" IS 'Precio de lista vigente.';
COMMENT ON COLUMN "core"."product"."created_at" IS 'Fecha de creación del registro.';
COMMENT ON COLUMN "core"."product"."updated_at" IS 'Fecha de la última modificación.';
COMMENT ON COLUMN "core"."product"."deleted_at" IS 'Fecha de baja lógica (soft delete).';

-- Comments: product_price_history
COMMENT ON TABLE "core"."product_price_history" IS 'Historial de precios de un producto por vigencia.';
COMMENT ON COLUMN "core"."product_price_history"."id" IS 'Identificador interno (PK).';
COMMENT ON COLUMN "core"."product_price_history"."product_id" IS 'Producto al que corresponde el precio.';
COMMENT ON COLUMN "core"."product_price_history"."price" IS 'Precio vigente durante el intervalo.';
COMMENT ON COLUMN "core"."product_price_history"."valid_from" IS 'Inicio de vigencia del precio.';
COMMENT ON COLUMN "core"."product_price_history"."valid_to" IS 'Fin de vigencia del precio; nulo si sigue vigente.';
COMMENT ON COLUMN "core"."product_price_history"."created_at" IS 'Fecha de creación del registro.';
COMMENT ON COLUMN "core"."product_price_history"."updated_at" IS 'Fecha de la última modificación.';
COMMENT ON COLUMN "core"."product_price_history"."deleted_at" IS 'Fecha de baja lógica (soft delete).';

-- Comments: company
COMMENT ON TABLE "core"."company" IS 'Empresa propietaria de una o más marcas.';
COMMENT ON COLUMN "core"."company"."id" IS 'Identificador interno (PK).';
COMMENT ON COLUMN "core"."company"."code" IS 'Código interno de la empresa; único.';
COMMENT ON COLUMN "core"."company"."name" IS 'Razón social o nombre comercial.';
COMMENT ON COLUMN "core"."company"."created_at" IS 'Fecha de creación del registro.';
COMMENT ON COLUMN "core"."company"."updated_at" IS 'Fecha de la última modificación.';
COMMENT ON COLUMN "core"."company"."deleted_at" IS 'Fecha de baja lógica (soft delete).';

-- Comments: brand
COMMENT ON TABLE "core"."brand" IS 'Marca comercial que agrupa productos de una empresa.';
COMMENT ON COLUMN "core"."brand"."id" IS 'Identificador interno (PK).';
COMMENT ON COLUMN "core"."brand"."company_id" IS 'Empresa propietaria de la marca.';
COMMENT ON COLUMN "core"."brand"."name" IS 'Nombre de la marca; único por empresa.';
COMMENT ON COLUMN "core"."brand"."description" IS 'Descripción opcional de la marca.';
COMMENT ON COLUMN "core"."brand"."created_at" IS 'Fecha de creación del registro.';
COMMENT ON COLUMN "core"."brand"."updated_at" IS 'Fecha de la última modificación.';
COMMENT ON COLUMN "core"."brand"."deleted_at" IS 'Fecha de baja lógica (soft delete).';

-- Comments: sales_point_inventory_review
COMMENT ON TABLE "core"."sales_point_inventory_review" IS 'Revisión de inventario realizada por un agente en un punto de venta.';
COMMENT ON COLUMN "core"."sales_point_inventory_review"."id" IS 'Identificador interno (PK).';
COMMENT ON COLUMN "core"."sales_point_inventory_review"."sales_point_id" IS 'Punto de venta revisado.';
COMMENT ON COLUMN "core"."sales_point_inventory_review"."sales_agent_id" IS 'Agente que realizó la revisión.';
COMMENT ON COLUMN "core"."sales_point_inventory_review"."visit_at" IS 'Momento de la visita.';
COMMENT ON COLUMN "core"."sales_point_inventory_review"."created_at" IS 'Fecha de creación del registro.';
COMMENT ON COLUMN "core"."sales_point_inventory_review"."updated_at" IS 'Fecha de la última modificación.';
COMMENT ON COLUMN "core"."sales_point_inventory_review"."deleted_at" IS 'Fecha de baja lógica (soft delete).';

-- Comments: product_item
COMMENT ON TABLE "core"."product_item" IS 'Detalle de inventario de un producto dentro de una revisión.';
COMMENT ON COLUMN "core"."product_item"."id" IS 'Identificador interno (PK).';
COMMENT ON COLUMN "core"."product_item"."inventory_review_id" IS 'Revisión de inventario a la que pertenece el ítem.';
COMMENT ON COLUMN "core"."product_item"."product_id" IS 'Producto inventariado.';
COMMENT ON COLUMN "core"."product_item"."warehouse_quantity" IS 'Cantidad disponible en bodega.';
COMMENT ON COLUMN "core"."product_item"."shelf_quantity" IS 'Cantidad disponible en estantería.';
COMMENT ON COLUMN "core"."product_item"."display_quantity" IS 'Cantidad disponible en exhibición.';
COMMENT ON COLUMN "core"."product_item"."recommended_quantity" IS 'Cantidad sugerida para reposición o pedido.';
COMMENT ON COLUMN "core"."product_item"."created_at" IS 'Fecha de creación del registro.';
COMMENT ON COLUMN "core"."product_item"."updated_at" IS 'Fecha de la última modificación.';
COMMENT ON COLUMN "core"."product_item"."deleted_at" IS 'Fecha de baja lógica (soft delete).';

-- Comments: sales_order
COMMENT ON TABLE "core"."sales_order" IS 'Pedido de venta registrado en un punto de venta; los totales se reconstruyen desde sus líneas.';
COMMENT ON COLUMN "core"."sales_order"."id" IS 'Identificador interno (PK).';
COMMENT ON COLUMN "core"."sales_order"."sales_point_id" IS 'Punto de venta donde se registra el pedido.';
COMMENT ON COLUMN "core"."sales_order"."sales_agent_id" IS 'Agente que registra el pedido.';
COMMENT ON COLUMN "core"."sales_order"."inventory_review_id" IS 'Revisión de inventario que originó el pedido (opcional).';
COMMENT ON COLUMN "core"."sales_order"."order_number" IS 'Número de pedido visible al negocio; único.';
COMMENT ON COLUMN "core"."sales_order"."ordered_at" IS 'Fecha y hora de registro del pedido.';
COMMENT ON COLUMN "core"."sales_order"."expected_delivery_at" IS 'Fecha de entrega comprometida.';
COMMENT ON COLUMN "core"."sales_order"."payment_method" IS 'Forma de pago acordada.';
COMMENT ON COLUMN "core"."sales_order"."fixed_space_fee" IS 'Cargo fijo por espacio acordado.';
COMMENT ON COLUMN "core"."sales_order"."percentage_space_fee" IS 'Cargo porcentual por espacio acordado.';
COMMENT ON COLUMN "core"."sales_order"."created_at" IS 'Fecha de creación del registro.';
COMMENT ON COLUMN "core"."sales_order"."updated_at" IS 'Fecha de la última modificación.';
COMMENT ON COLUMN "core"."sales_order"."deleted_at" IS 'Fecha de baja lógica (soft delete).';

-- Comments: sales_order_item
COMMENT ON TABLE "core"."sales_order_item" IS 'Línea de pedido: un producto con cantidad, precio y descuento.';
COMMENT ON COLUMN "core"."sales_order_item"."id" IS 'Identificador interno (PK).';
COMMENT ON COLUMN "core"."sales_order_item"."sales_order_id" IS 'Pedido al que pertenece la línea.';
COMMENT ON COLUMN "core"."sales_order_item"."product_id" IS 'Producto vendido.';
COMMENT ON COLUMN "core"."sales_order_item"."quantity" IS 'Cantidad pedida.';
COMMENT ON COLUMN "core"."sales_order_item"."unit_price" IS 'Precio unitario de lista.';
COMMENT ON COLUMN "core"."sales_order_item"."unit_discounted_price" IS 'Precio unitario con descuento aplicado.';
COMMENT ON COLUMN "core"."sales_order_item"."subtotal_amount" IS 'Importe antes de descuento (cantidad x precio unitario).';
COMMENT ON COLUMN "core"."sales_order_item"."discount_amount" IS 'Descuento monetario aplicado a la línea.';
COMMENT ON COLUMN "core"."sales_order_item"."total_amount" IS 'Importe final de la línea.';
COMMENT ON COLUMN "core"."sales_order_item"."created_at" IS 'Fecha de creación del registro.';
COMMENT ON COLUMN "core"."sales_order_item"."updated_at" IS 'Fecha de la última modificación.';
COMMENT ON COLUMN "core"."sales_order_item"."deleted_at" IS 'Fecha de baja lógica (soft delete).';
