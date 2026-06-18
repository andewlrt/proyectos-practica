# 🛍️ Catálogo de Productos - Base de Datos SQL

Base de datos para un catálogo de productos con ventas y clientes.

## Tablas creadas
- **categorias** - Categorías de productos
- **productos** - Catálogo con precio y stock
- **clientes** - Información de clientes
- **ventas** - Registro de compras

## Cómo usarlo

### Con SQLite (más fácil):
```bash
sqlite3 tienda.db < catalogo.sql
```

### Con MySQL:
```bash
mysql -u root -p mi_tienda < catalogo.sql
```

## Consultas incluidas
- Ver productos por categoría
- Top 5 productos más caros
- Productos con poco stock
- Total gastado por cliente
- Ventas por categoría
- Valor total del inventario

## Conceptos usados
- CREATE TABLE
- INSERT INTO
- SELECT con JOIN
- GROUP BY y ORDER BY
- Claves foráneas (FOREIGN KEY)
- Funciones agregadas (SUM, COUNT)
