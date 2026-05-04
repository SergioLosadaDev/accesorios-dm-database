-- =====================================================
-- DATOS INICIALES
-- Descripción: Inserts de datos maestros para el sistema
-- =====================================================

-- =====================================================
-- 1. ROLES (security.rol) - Tiene UNIQUE en nombre
-- =====================================================
INSERT INTO security.rol (nombre, descripcion) VALUES
    ('ADMIN', 'Administrador del sistema - Acceso total'),
    ('VENDEDOR', 'Vendedor - Gestión de ventas y clientes'),
    ('BODEGUERO', 'Encargado de inventario - Gestión de productos y stock'),
    ('CLIENTE', 'Cliente del sistema - Compra de productos')
ON CONFLICT (nombre) DO NOTHING;

-- =====================================================
-- 2. ESTADOS DE PEDIDO (logistica.estado_pedido) - Tiene UNIQUE en nombre
-- =====================================================
INSERT INTO logistica.estado_pedido (nombre, descripcion) VALUES
    ('PENDIENTE', 'Pedido creado, esperando confirmación de pago'),
    ('PAGADO', 'Pago confirmado, preparando envío'),
    ('ENVIADO', 'Pedido enviado al cliente'),
    ('ENTREGADO', 'Pedido entregado exitosamente'),
    ('CANCELADO', 'Pedido cancelado')
ON CONFLICT (nombre) DO NOTHING;

-- =====================================================
-- 3. TIPOS DE MOVIMIENTO DE INVENTARIO (inventario.tipo_movimiento) - Tiene UNIQUE en nombre
-- =====================================================
INSERT INTO inventario.tipo_movimiento (nombre, descripcion) VALUES
    ('ENTRADA', 'Ingreso de productos al inventario (compras, devoluciones)'),
    ('SALIDA', 'Salida de productos del inventario (ventas, pérdidas)'),
    ('AJUSTE', 'Ajuste manual de inventario (inventario físico)')
ON CONFLICT (nombre) DO NOTHING;

-- =====================================================
-- 4. MATERIALES BASE (catalogo.material) - Tiene UNIQUE en nombre
-- =====================================================
INSERT INTO catalogo.material (nombre, descripcion) VALUES
    ('Oro 18K', 'Oro de 18 quilates - Alta pureza'),
    ('Oro 14K', 'Oro de 14 quilates'),
    ('Plata 925', 'Plata esterlina 92.5%'),
    ('Acero Inoxidable', 'Acero inoxidable quirúrgico'),
    ('Titanio', 'Titanio hipoalergénico'),
    ('Cobre', 'Cobre con acabado especial'),
    ('Plata de Ley', 'Plata de ley mexicana')
ON CONFLICT (nombre) DO NOTHING;

-- =====================================================
-- 5. CATEGORÍAS BASE (catalogo.categoria) - Tiene UNIQUE en nombre
-- =====================================================
INSERT INTO catalogo.categoria (nombre, descripcion, estado) VALUES
    ('Anillos', 'Anillos en diferentes estilos y materiales', TRUE),
    ('Collares', 'Collares y gargantillas', TRUE),
    ('Pulseras', 'Pulseras y brazaletes', TRUE),
    ('Aretes', 'Aretes y pendientes', TRUE),
    ('Dijes', 'Dijes y charms', TRUE),
    ('Llaveros', 'Llaveros decorativos', TRUE),
    ('Conjuntos', 'Conjuntos de joyería', TRUE)
ON CONFLICT (nombre) DO NOTHING;

-- =====================================================
-- 6. PRODUCTOS DE EJEMPLO (catalogo.producto) - NO tiene UNIQUE en nombre
-- Usamos DO NOTHING sin ON CONFLICT (verificamos existencia manualmente)
-- =====================================================
INSERT INTO catalogo.producto (nombre, descripcion, precio, stock, estado, id_categoria, id_material)
SELECT * FROM (
    VALUES
        ('Anillo de compromiso Oro 18K', 'Anillo de compromiso con diamante central, acabado brillante', 2500000.00, 5, TRUE, 
         (SELECT id_categoria FROM catalogo.categoria WHERE nombre = 'Anillos'),
         (SELECT id_material FROM catalogo.material WHERE nombre = 'Oro 18K')),
        ('Collar de Perlas Plata 925', 'Collar de perlas cultivadas con cierre de plata 925', 850000.00, 10, TRUE,
         (SELECT id_categoria FROM catalogo.categoria WHERE nombre = 'Collares'),
         (SELECT id_material FROM catalogo.material WHERE nombre = 'Plata 925')),
        ('Pulsera de Acero Inoxidable', 'Pulsera estilo eslabón, acero inoxidable color plata', 150000.00, 25, TRUE,
         (SELECT id_categoria FROM catalogo.categoria WHERE nombre = 'Pulseras'),
         (SELECT id_material FROM catalogo.material WHERE nombre = 'Acero Inoxidable')),
        ('Aretes de Oro 14K', 'Aretes tipo aro, oro 14K, tamaño pequeño', 450000.00, 15, TRUE,
         (SELECT id_categoria FROM catalogo.categoria WHERE nombre = 'Aretes'),
         (SELECT id_material FROM catalogo.material WHERE nombre = 'Oro 14K')),
        ('Dije de Corazón Plata 925', 'Dije de corazón en plata 925 con grabado', 89000.00, 30, TRUE,
         (SELECT id_categoria FROM catalogo.categoria WHERE nombre = 'Dijes'),
         (SELECT id_material FROM catalogo.material WHERE nombre = 'Plata 925')),
        ('Anillo de Plata Ley', 'Anillo de plata de ley con piedra lunar', 320000.00, 20, TRUE,
         (SELECT id_categoria FROM catalogo.categoria WHERE nombre = 'Anillos'),
         (SELECT id_material FROM catalogo.material WHERE nombre = 'Plata de Ley')),
        ('Collar de Titanio Hombre', 'Collar de cadena gruesa en titanio para hombre', 250000.00, 12, TRUE,
         (SELECT id_categoria FROM catalogo.categoria WHERE nombre = 'Collares'),
         (SELECT id_material FROM catalogo.material WHERE nombre = 'Titanio')),
        ('Pulsera de Cobre Energía', 'Pulsera magnética de cobre para energía', 120000.00, 18, TRUE,
         (SELECT id_categoria FROM catalogo.categoria WHERE nombre = 'Pulseras'),
         (SELECT id_material FROM catalogo.material WHERE nombre = 'Cobre'))
) AS v(nombre, descripcion, precio, stock, estado, id_categoria, id_material)
WHERE NOT EXISTS (SELECT 1 FROM catalogo.producto p WHERE p.nombre = v.nombre);

-- =====================================================
-- 7. CLIENTE DE EJEMPLO (clientes.cliente) - Tiene UNIQUE en correo
-- =====================================================
INSERT INTO clientes.cliente (nombre, correo, telefono) VALUES
    ('Cliente Demo', 'demo@accesoriosdm.com', '3001234567')
ON CONFLICT (correo) DO NOTHING;

-- =====================================================
-- 8. EMPLEADO ADMIN (security.empleado) - Tiene UNIQUE en correo
-- Nota: La contraseña en producción debe ser encriptada con bcrypt
-- Por ahora usamos un hash de ejemplo para 'admin123'
-- =====================================================
INSERT INTO security.empleado (nombre, correo, password, estado, id_rol) VALUES
    (
        'Administrador Sistema', 
        'admin@accesoriosdm.com', 
        '$2a$10$8KzYzKzYzKzYzKzYzKzYuO9kKzYzKzYzKzYzKzYzKzYzKzYzK',  -- Hash de 'admin123'
        TRUE, 
        (SELECT id_rol FROM security.rol WHERE nombre = 'ADMIN')
    ),
    (
        'Vendedor Demo', 
        'vendedor@accesoriosdm.com', 
        '$2a$10$8KzYzKzYzKzYzKzYzKzYuO9kKzYzKzYzKzYzKzYzKzYzKzYzK',  -- Hash de 'admin123'
        TRUE, 
        (SELECT id_rol FROM security.rol WHERE nombre = 'VENDEDOR')
    )
ON CONFLICT (correo) DO NOTHING;