-- =====================================================
-- TRIGGERS PARA INVENTARIO
-- Schema: inventario
-- =====================================================

-- Trigger: Actualizar stock al insertar
CREATE TRIGGER trg_update_stock_on_insert
    AFTER INSERT ON inventario.inventario_movimiento
    FOR EACH ROW
    EXECUTE FUNCTION inventario.f_update_stock_on_insert();

-- Trigger: Actualizar stock al modificar
CREATE TRIGGER trg_update_stock_on_update
    AFTER UPDATE OF cantidad ON inventario.inventario_movimiento
    FOR EACH ROW
    EXECUTE FUNCTION inventario.f_update_stock_on_update();

-- Trigger: Revertir stock al eliminar
CREATE TRIGGER trg_revert_stock_on_delete
    BEFORE DELETE ON inventario.inventario_movimiento
    FOR EACH ROW
    EXECUTE FUNCTION inventario.f_revert_stock_on_delete();