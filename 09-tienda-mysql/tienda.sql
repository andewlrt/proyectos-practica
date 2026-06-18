-- =============================================
-- TIENDA ONLINE - Base de datos MySQL
-- Sistema completo con usuarios, productos, pedidos
-- =============================================

CREATE DATABASE IF NOT EXISTS tienda_online;
USE tienda_online;

-- Tabla de usuarios
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    tipo ENUM('cliente', 'admin') DEFAULT 'cliente',
    fecha_registro DATETIME DEFAULT NOW(),
    activo BOOLEAN DEFAULT TRUE
);

-- Tabla de categorías
CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    slug VARCHAR(100) UNIQUE,
    imagen VARCHAR(255)
);

-- Tabla de productos
CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(12,2) NOT NULL,
    precio_descuento DECIMAL(12,2),
    stock INT DEFAULT 0,
    categoria_id INT,
    imagen VARCHAR(255),
    activo BOOLEAN DEFAULT TRUE,
    creado_en DATETIME DEFAULT NOW(),
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

-- Tabla de pedidos
CREATE TABLE pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    estado ENUM('pendiente', 'pagado', 'enviado', 'entregado', 'cancelado') DEFAULT 'pendiente',
    total DECIMAL(12,2),
    direccion_envio TEXT,
    metodo_pago VARCHAR(50),
    fecha_pedido DATETIME DEFAULT NOW(),
    fecha_entrega DATETIME,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Detalle de cada pedido (qué productos y cuántos)
CREATE TABLE detalle_pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(12,2) NOT NULL,
    subtotal DECIMAL(12,2),
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- Tabla de reseñas
CREATE TABLE resenas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT NOT NULL,
    usuario_id INT NOT NULL,
    calificacion INT CHECK (calificacion BETWEEN 1 AND 5),
    comentario TEXT,
    fecha DATETIME DEFAULT NOW(),
    FOREIGN KEY (producto_id) REFERENCES productos(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- =============================================
-- DATOS DE EJEMPLO
-- =============================================

INSERT INTO usuarios (nombre, apellido, email, contrasena, tipo) VALUES
('Admin', 'Sistema', 'admin@tienda.com', 'hash_contrasena_aqui', 'admin'),
('Carlos', 'López', 'carlos@email.com', 'hash_contrasena_aqui', 'cliente'),
('María', 'García', 'maria@email.com', 'hash_contrasena_aqui', 'cliente'),
('Pedro', 'Jiménez', 'pedro@email.com', 'hash_contrasena_aqui', 'cliente');

INSERT INTO categorias (nombre, slug) VALUES
('Laptops', 'laptops'),
('Celulares', 'celulares'),
('Accesorios', 'accesorios'),
('Tablets', 'tablets');

INSERT INTO productos (nombre, descripcion, precio, precio_descuento, stock, categoria_id) VALUES
('MacBook Air M2', 'Laptop ultradelgada con chip M2, 8GB RAM, 256GB', 6500000, 6200000, 8, 1),
('Lenovo IdeaPad 3', 'Laptop Intel i5, 12GB RAM, 512GB SSD, pantalla 15"', 2800000, NULL, 15, 1),
('Samsung Galaxy S24', 'Celular 6.2", 8GB RAM, cámara 50MP, batería 4000mAh', 3200000, 2900000, 20, 2),
('iPhone 15', 'Pantalla Super Retina, chip A16, cámara 48MP', 4800000, NULL, 12, 2),
('Motorola Edge 40', 'Celular 5G, pantalla OLED 144Hz, carga rápida 68W', 1800000, 1650000, 25, 2),
('AirPods Pro 2', 'Audífonos inalámbricos con cancelación de ruido', 1200000, NULL, 30, 3),
('Mouse Logitech MX Master 3', 'Mouse inalámbrico ergonómico para productividad', 380000, 320000, 40, 3),
('iPad Air', 'Tablet 10.9", chip M1, 64GB, WiFi', 2400000, NULL, 10, 4);

INSERT INTO pedidos (usuario_id, estado, total, direccion_envio, metodo_pago) VALUES
(2, 'entregado', 3200000, 'Calle 45 # 12-30, Bogotá', 'tarjeta_credito'),
(2, 'enviado', 380000, 'Calle 45 # 12-30, Bogotá', 'pse'),
(3, 'pagado', 7700000, 'Carrera 70 # 25-15, Medellín', 'tarjeta_debito'),
(4, 'pendiente', 1650000, 'Avenida 30 # 8-90, Cali', 'efecty');

INSERT INTO detalle_pedidos (pedido_id, producto_id, cantidad, precio_unitario, subtotal) VALUES
(1, 3, 1, 3200000, 3200000),
(2, 7, 1, 380000, 380000),
(3, 1, 1, 6200000, 6200000),
(3, 6, 1, 1200000, 1200000),
(4, 5, 1, 1650000, 1650000);

INSERT INTO resenas (producto_id, usuario_id, calificacion, comentario) VALUES
(3, 2, 5, 'Excelente celular, la cámara es increíble'),
(7, 2, 4, 'Muy buen mouse, cómodo para trabajar todo el día'),
(1, 3, 5, 'La mejor laptop que he tenido, batería dura todo el día'),
(6, 3, 4, 'Buen sonido, el modo transparencia está muy bien');

-- =============================================
-- CONSULTAS ÚTILES
-- =============================================

-- Ver todos los pedidos con info del cliente
SELECT p.id, u.nombre, u.apellido, p.estado, p.total, p.fecha_pedido
FROM pedidos p
JOIN usuarios u ON p.usuario_id = u.id
ORDER BY p.fecha_pedido DESC;

-- Productos más vendidos
SELECT pr.nombre, SUM(dp.cantidad) as unidades_vendidas, SUM(dp.subtotal) as ingresos
FROM detalle_pedidos dp
JOIN productos pr ON dp.producto_id = pr.id
GROUP BY pr.id, pr.nombre
ORDER BY unidades_vendidas DESC;

-- Calificación promedio de cada producto
SELECT p.nombre, ROUND(AVG(r.calificacion), 1) as promedio, COUNT(r.id) as num_resenas
FROM productos p
LEFT JOIN resenas r ON p.id = r.producto_id
GROUP BY p.id, p.nombre
ORDER BY promedio DESC;

-- Ingresos totales por mes
SELECT DATE_FORMAT(fecha_pedido, '%Y-%m') as mes, SUM(total) as ingresos, COUNT(*) as pedidos
FROM pedidos
WHERE estado != 'cancelado'
GROUP BY mes
ORDER BY mes;

-- Clientes que más han comprado
SELECT u.nombre, u.apellido, COUNT(p.id) as num_pedidos, SUM(p.total) as total_gastado
FROM usuarios u
JOIN pedidos p ON u.id = p.usuario_id
WHERE u.tipo = 'cliente'
GROUP BY u.id, u.nombre, u.apellido
ORDER BY total_gastado DESC;

-- Productos con descuento activo
SELECT nombre, precio, precio_descuento,
       ROUND((precio - precio_descuento) / precio * 100) as descuento_porcentaje
FROM productos
WHERE precio_descuento IS NOT NULL
ORDER BY descuento_porcentaje DESC;
