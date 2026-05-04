-- =====================================================
-- FUNCIONES PARA ACTUALIZAR STOCK
-- Schema: inventario
-- =====================================================

-- Función: Actualizar stock cuando se inserta un movimiento
CREATE OR REPLACE FUNCTION inventario.f_update_stock_on_insert()
RETURNS TRIGGER AS $$
BEGIN
    -- Actualizar el stock del producto
    UPDATE catalogo.producto
    SET stock = stock + NEW.cantidad
    WHERE id_producto = NEW.id_producto;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION inventario.f_update_stock_on_insert() IS 'Trigger: actualiza stock al insertar movimiento de inventario';

-- Función: Actualizar stock cuando se actualiza un movimiento
CREATE OR REPLACE FUNCTION inventario.f_update_stock_on_update()
RETURNS TRIGGER AS $$
BEGIN
    -- Revertir el cambio anterior y aplicar el nuevo
    UPDATE catalogo.producto
    SET stock = stock - OLD.cantidad + NEW.cantidad
    WHERE id_producto = NEW.id_producto;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION inventario.f_update_stock_on_update() IS 'Trigger: actualiza stock al modificar movimiento';

-- Función: Revertir stock cuando se elimina un movimiento
CREATE OR REPLACE FUNCTION inventario.f_revert_stock_on_delete()
RETURNS TRIGGER AS $$
BEGIN
    -- Restar la cantidad que se había agregado
    UPDATE catalogo.producto
    SET stock = stock - OLD.cantidad
    WHERE id_producto = OLD.id_producto;
    
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION inventario.f_revert_stock_on_delete() IS 'Trigger: revierte stock al eliminar movimiento';