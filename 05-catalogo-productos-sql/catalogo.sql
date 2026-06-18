-- =============================================
-- CATÁLOGO DE PRODUCTOS - Base de datos SQL
-- Proyecto de práctica con SQLite / MySQL
-- =============================================

-- Crear tabla de categorías
CREATE TABLE categorias (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT
);

-- Crear tabla de productos
CREATE TABLE productos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    stock INTEGER DEFAULT 0,
    categoria_id INTEGER,
    fecha_agregado DATE DEFAULT CURRENT_DATE,
    activo BOOLEAN DEFAULT 1,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

-- Crear tabla de clientes
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    ciudad VARCHAR(100)
);

-- Crear tabla de ventas
CREATE TABLE ventas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    cliente_id INTEGER,
    producto_id INTEGER,
    cantidad INTEGER NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    total DECIMAL(10, 2),
    fecha_venta DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- =============================================
-- INSERTAR DATOS DE EJEMPLO
-- =============================================

INSERT INTO categorias (nombre, descripcion) VALUES
('Electrónica', 'Dispositivos y gadgets electrónicos'),
('Ropa', 'Ropa y accesorios de moda'),
('Hogar', 'Artículos para el hogar'),
('Deportes', 'Equipos y ropa deportiva'),
('Libros', 'Libros y material educativo');

INSERT INTO productos (nombre, descripcion, precio, stock, categoria_id) VALUES
('Laptop HP 15"', 'Laptop con procesador Intel i5, 8GB RAM, 256GB SSD', 2500000, 15, 1),
('Mouse Inalámbrico', 'Mouse ergonómico Bluetooth con batería recargable', 85000, 50, 1),
('Teclado Mecánico', 'Teclado mecánico RGB para gaming', 250000, 30, 1),
('Audífonos Sony', 'Audífonos con cancelación de ruido', 450000, 20, 1),
('Camiseta Polo', 'Camiseta polo de algodón 100%', 45000, 100, 2),
('Jeans Clásico', 'Jeans azul clásico corte recto', 120000, 60, 2),
('Tenis Deportivos', 'Tenis para correr con suela reforzada', 280000, 40, 2),
('Silla de Oficina', 'Silla ergonómica con soporte lumbar', 650000, 10, 3),
('Lámpara LED', 'Lámpara de escritorio con control de intensidad', 95000, 25, 3),
('Colchón Queen', 'Colchón ortopédico tamaño queen', 1800000, 5, 3),
('Balón de Fútbol', 'Balón oficial tamaño 5', 75000, 35, 4),
('Guantes de Boxeo', 'Guantes de cuero para entrenamiento', 180000, 18, 4),
('Libro Python Básico', 'Aprende Python desde cero', 55000, 80, 5),
('Libro SQL Completo', 'Guía completa de bases de datos SQL', 65000, 45, 5);

INSERT INTO clientes (nombre, apellido, email, telefono, ciudad) VALUES
('Carlos', 'Rodríguez', 'carlos.rodriguez@email.com', '3101234567', 'Bogotá'),
('María', 'González', 'maria.gonzalez@email.com', '3207654321', 'Medellín'),
('Andrés', 'Martínez', 'andres.martinez@email.com', '3159876543', 'Cali'),
('Laura', 'Pérez', 'laura.perez@email.com', '3001112233', 'Barranquilla'),
('Diego', 'Torres', 'diego.torres@email.com', '3184445566', 'Bogotá');

INSERT INTO ventas (cliente_id, producto_id, cantidad, precio_unitario, total) VALUES
(1, 1, 1, 2500000, 2500000),
(1, 2, 2, 85000, 170000),
(2, 5, 3, 45000, 135000),
(2, 6, 1, 120000, 120000),
(3, 11, 2, 75000, 150000),
(3, 12, 1, 180000, 180000),
(4, 13, 1, 55000, 55000),
(4, 14, 1, 65000, 65000),
(5, 3, 1, 250000, 250000),
(5, 4, 1, 450000, 450000),
(1, 8, 1, 650000, 650000),
(2, 9, 2, 95000, 190000);

-- =============================================
-- CONSULTAS ÚTILES
-- =============================================

-- Ver todos los productos con su categoría
SELECT p.nombre, p.precio, p.stock, c.nombre as categoria
FROM productos p
JOIN categorias c ON p.categoria_id = c.id
ORDER BY c.nombre, p.nombre;

-- Ver los 5 productos más caros
SELECT nombre, precio, stock
FROM productos
ORDER BY precio DESC
LIMIT 5;

-- Ver productos con poco stock (menos de 20 unidades)
SELECT nombre, stock, precio
FROM productos
WHERE stock < 20
ORDER BY stock ASC;

-- Total de ventas por cliente
SELECT c.nombre, c.apellido, COUNT(v.id) as num_compras, SUM(v.total) as total_gastado
FROM clientes c
LEFT JOIN ventas v ON c.id = v.cliente_id
GROUP BY c.id, c.nombre, c.apellido
ORDER BY total_gastado DESC;

-- Ventas por categoría
SELECT cat.nombre as categoria, COUNT(v.id) as ventas, SUM(v.total) as ingresos
FROM ventas v
JOIN productos p ON v.producto_id = p.id
JOIN categorias cat ON p.categoria_id = cat.id
GROUP BY cat.id, cat.nombre
ORDER BY ingresos DESC;

-- Buscar productos por nombre
SELECT * FROM productos WHERE nombre LIKE '%Laptop%';

-- Calcular valor total del inventario
SELECT SUM(precio * stock) as valor_inventario FROM productos;
