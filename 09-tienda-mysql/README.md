#  Tienda Online - Base de Datos MySQL

Base de datos completa para una tienda online con usuarios, pedidos y reseñas.

## Tablas del sistema
| Tabla | Descripción |
|-------|-------------|
| usuarios | Clientes y administradores |
| categorias | Categorías de productos |
| productos | Catálogo con precios y descuentos |
| pedidos | Órdenes de compra |
| detalle_pedidos | Productos en cada pedido |
| resenas | Calificaciones y comentarios |

## Cómo importarlo
```bash
mysql -u root -p < tienda.sql
```

O desde MySQL Workbench: File > Run SQL Script

## Consultas incluidas
- Pedidos con información del cliente
- Productos más vendidos
- Calificación promedio de productos
- Ingresos por mes
- Clientes que más compran
- Productos con descuento

## Tecnologías
- MySQL
- SQL con JOIN, GROUP BY, funciones de fecha
- Relaciones entre tablas (Foreign Keys)
