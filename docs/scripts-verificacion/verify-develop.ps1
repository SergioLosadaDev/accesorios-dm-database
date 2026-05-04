# verify-develop.ps1
# Script de verificación para ambiente DEVELOP (puerto 5432)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "VERIFICANDO BASE DE DATOS - DEVELOP" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Variables
$CONTAINER = "accesorios-dm-postgres-dev"
$DB = "accesorios_dm_db"
$USER = "admin"

Write-Host "📌 Verificando que el contenedor está corriendo..." -ForegroundColor Yellow
docker ps --filter "name=$CONTAINER" --format "table {{.Names}}\t{{.Status}}"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "1. VERIFICANDO SCHEMAS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
docker exec -it $CONTAINER psql -U $USER -d $DB -c "\dn"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "2. VERIFICANDO EXTENSIONES" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
docker exec -it $CONTAINER psql -U $USER -d $DB -c "\dx"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "3. VERIFICANDO TABLAS - SECURITY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
docker exec -it $CONTAINER psql -U $USER -d $DB -c "\dt security.*"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "4. VERIFICANDO TABLAS - CLIENTES" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
docker exec -it $CONTAINER psql -U $USER -d $DB -c "\dt clientes.*"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "5. VERIFICANDO TABLAS - CATALOGO" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
docker exec -it $CONTAINER psql -U $USER -d $DB -c "\dt catalogo.*"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "6. VERIFICANDO TABLAS - PROMOCIONES" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
docker exec -it $CONTAINER psql -U $USER -d $DB -c "\dt promociones.*"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "7. VERIFICANDO TABLAS - VENTAS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
docker exec -it $CONTAINER psql -U $USER -d $DB -c "\dt ventas.*"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "8. VERIFICANDO TABLAS - LOGISTICA" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
docker exec -it $CONTAINER psql -U $USER -d $DB -c "\dt logistica.*"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "9. VERIFICANDO TABLAS - INVENTARIO" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
docker exec -it $CONTAINER psql -U $USER -d $DB -c "\dt inventario.*"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "10. VERIFICANDO LLAVES FORÁNEAS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "🔗 security.empleado -> security.rol" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT conname FROM pg_constraint WHERE conrelid = 'security.empleado'::regclass AND contype = 'f';"

Write-Host "🔗 catalogo.producto -> catalogo.categoria" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT conname FROM pg_constraint WHERE conrelid = 'catalogo.producto'::regclass AND contype = 'f';"

Write-Host "🔗 catalogo.producto -> catalogo.material" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT conname FROM pg_constraint WHERE conrelid = 'catalogo.producto'::regclass AND contype = 'f' AND conname LIKE '%material%';"

Write-Host "🔗 catalogo.imagen_producto -> catalogo.producto" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT conname FROM pg_constraint WHERE conrelid = 'catalogo.imagen_producto'::regclass AND contype = 'f';"

Write-Host "🔗 promociones.promocion_producto -> promociones.promocion" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT conname FROM pg_constraint WHERE conrelid = 'promociones.promocion_producto'::regclass AND contype = 'f' AND conname LIKE '%promocion%';"

Write-Host "🔗 promociones.promocion_producto -> catalogo.producto" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT conname FROM pg_constraint WHERE conrelid = 'promociones.promocion_producto'::regclass AND contype = 'f' AND conname LIKE '%producto%';"

Write-Host "🔗 ventas.carrito -> clientes.cliente" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT conname FROM pg_constraint WHERE conrelid = 'ventas.carrito'::regclass AND contype = 'f';"

Write-Host "🔗 ventas.item_carrito -> ventas.carrito" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT conname FROM pg_constraint WHERE conrelid = 'ventas.item_carrito'::regclass AND contype = 'f' AND conname LIKE '%carrito%';"

Write-Host "🔗 ventas.item_carrito -> catalogo.producto" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT conname FROM pg_constraint WHERE conrelid = 'ventas.item_carrito'::regclass AND contype = 'f' AND conname LIKE '%producto%';"

Write-Host "🔗 ventas.pedido -> clientes.cliente" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT conname FROM pg_constraint WHERE conrelid = 'ventas.pedido'::regclass AND contype = 'f' AND conname LIKE '%cliente%';"

Write-Host "🔗 ventas.pedido -> logistica.estado_pedido" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT conname FROM pg_constraint WHERE conrelid = 'ventas.pedido'::regclass AND contype = 'f' AND conname LIKE '%estado%';"

Write-Host "🔗 logistica.historial_estado_pedido -> ventas.pedido" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT conname FROM pg_constraint WHERE conrelid = 'logistica.historial_estado_pedido'::regclass AND contype = 'f' AND conname LIKE '%pedido%';"

Write-Host "🔗 logistica.historial_estado_pedido -> logistica.estado_pedido" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT conname FROM pg_constraint WHERE conrelid = 'logistica.historial_estado_pedido'::regclass AND contype = 'f' AND conname LIKE '%estado%' AND conname != 'fk_historial_pedido';"

Write-Host "🔗 ventas.detalle_pedido -> ventas.pedido" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT conname FROM pg_constraint WHERE conrelid = 'ventas.detalle_pedido'::regclass AND contype = 'f' AND conname LIKE '%pedido%';"

Write-Host "🔗 ventas.detalle_pedido -> catalogo.producto" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT conname FROM pg_constraint WHERE conrelid = 'ventas.detalle_pedido'::regclass AND contype = 'f' AND conname LIKE '%producto%';"

Write-Host "🔗 inventario.inventario_movimiento -> catalogo.producto" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT conname FROM pg_constraint WHERE conrelid = 'inventario.inventario_movimiento'::regclass AND contype = 'f' AND conname LIKE '%producto%';"

Write-Host "🔗 inventario.inventario_movimiento -> inventario.tipo_movimiento" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT conname FROM pg_constraint WHERE conrelid = 'inventario.inventario_movimiento'::regclass AND contype = 'f' AND conname LIKE '%tipo%';"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "11. VERIFICANDO ÍNDICES" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "📊 Índices en catalogo" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "\di catalogo.*"

Write-Host "📊 Índices en promociones" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "\di promociones.*"

Write-Host "📊 Índices en ventas" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "\di ventas.*"

Write-Host "📊 Índices en logistica" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "\di logistica.*"

Write-Host "📊 Índices en inventario" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "\di inventario.*"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "12. VERIFICANDO RESTRICCIONES CHECK" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "✅ ventas.item_carrito - cantidad > 0" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT conname FROM pg_constraint WHERE conrelid = 'ventas.item_carrito'::regclass AND contype = 'c' AND conname LIKE '%cantidad%';"

Write-Host "✅ ventas.item_carrito - precio_unitario > 0" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT conname FROM pg_constraint WHERE conrelid = 'ventas.item_carrito'::regclass AND contype = 'c' AND conname LIKE '%precio%';"

Write-Host "✅ ventas.carrito - estado válido (activo/procesado/abandonado)" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT conname FROM pg_constraint WHERE conrelid = 'ventas.carrito'::regclass AND contype = 'c';"

Write-Host "✅ ventas.detalle_pedido - cantidad > 0" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT conname FROM pg_constraint WHERE conrelid = 'ventas.detalle_pedido'::regclass AND contype = 'c' AND conname LIKE '%cantidad%';"

Write-Host "✅ ventas.detalle_pedido - precio_unitario > 0" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT conname FROM pg_constraint WHERE conrelid = 'ventas.detalle_pedido'::regclass AND contype = 'c' AND conname LIKE '%precio%';"

Write-Host "✅ ventas.pedido - total > 0" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT conname FROM pg_constraint WHERE conrelid = 'ventas.pedido'::regclass AND contype = 'c';"

Write-Host "✅ inventario.inventario_movimiento - cantidad != 0" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT conname FROM pg_constraint WHERE conrelid = 'inventario.inventario_movimiento'::regclass AND contype = 'c';"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "13. VERIFICANDO DATOS INICIALES" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "📋 Roles:" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT id_rol, nombre, descripcion FROM security.rol;"

Write-Host "📋 Estados de Pedido:" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT id_estado, nombre, descripcion FROM logistica.estado_pedido;"

Write-Host "📋 Tipos de Movimiento:" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT id_tipo_movimiento, nombre, descripcion FROM inventario.tipo_movimiento;"

Write-Host "📋 Materiales:" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT id_material, nombre FROM catalogo.material;"

Write-Host "📋 Categorías:" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT id_categoria, nombre, estado FROM catalogo.categoria;"

Write-Host "📋 Productos Demo:" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT id_producto, nombre, precio, stock FROM catalogo.producto;"

Write-Host "📋 Cliente Demo:" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT id_cliente, nombre, correo FROM clientes.cliente WHERE correo = 'demo@accesoriosdm.com';"

Write-Host "📋 Empleados:" -ForegroundColor Yellow
docker exec -it $CONTAINER psql -U $USER -d $DB -c "SELECT id_empleado, nombre, correo, id_rol FROM security.empleado;"

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "✅ VERIFICACIÓN COMPLETADA - DEVELOP" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green