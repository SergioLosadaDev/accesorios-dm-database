-- =====================================================
-- FUNCIONES PARA ACTUALIZAR STOCK
-- Schema: inventario
-- =====================================================

-- IMPORTANTE: Las funciones se crean manualmente después
-- debido a problemas de parsing con Liquibase

-- CREATE OR REPLACE FUNCTION inventario.f_update_stock_on_insert() RETURNS TRIGGER LANGUAGE plpgsql AS $_$ BEGIN UPDATE catalogo.producto SET stock = stock + NEW.cantidad WHERE id_producto = NEW.id_producto; RETURN NEW; END; $_$;

-- CREATE OR REPLACE FUNCTION inventario.f_update_stock_on_update() RETURNS TRIGGER LANGUAGE plpgsql AS $_$ BEGIN UPDATE catalogo.producto SET stock = stock - OLD.cantidad + NEW.cantidad WHERE id_producto = NEW.id_producto; RETURN NEW; END; $_$;

-- CREATE OR REPLACE FUNCTION inventario.f_revert_stock_on_delete() RETURNS TRIGGER LANGUAGE plpgsql AS $_$ BEGIN UPDATE catalogo.producto SET stock = stock - OLD.cantidad WHERE id_producto = OLD.id_producto; RETURN OLD; END; $_$;

-- Placeholder para que Liquibase no falle
SELECT 1;